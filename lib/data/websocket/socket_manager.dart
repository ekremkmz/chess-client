import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chess/helper/move_helper.dart';
import 'package:chess/logic/cubit/game_board_logic/piece_color.dart';

import '../runtime/user_manager.dart';

import '../runtime/game_requests_manager.dart';
import '../runtime/friend_status_manager.dart';
import '../../models/friend.dart';
import 'package:get_it/get_it.dart';

import '../local/models/game.dart';
import '../local/models/player_state.dart';
import 'commands/check_all_status_command.dart';
import '../../models/game_request.dart';

import '../../errors/failure.dart';
import '../../logic/cubit/game_board_logic/chess_coord.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../local/db_manager.dart';
import '../globals.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'commands/command.dart';
import 'commands/connect_to_game_command.dart';

class SocketManager {
  SocketManager();

  final StreamController<ConnectionState> _connectionStateController =
      StreamController()..add(ConnectionState.done);

  Stream<ConnectionState> get connectionStateStream =>
      _connectionStateController.stream;

  ConnectionState _connectionState = ConnectionState.done;

  ConnectionState get _state => _connectionState;
  set _state(ConnectionState state) {
    _connectionState = state;
    _connectionStateController.add(state);
  }

  IOWebSocketChannel? _socket;
  StreamSubscription<dynamic>? _subscription;

  bool _initLocked = false;
  int _connectionAttempts = 0;
  final Map<String, Command> _waitingAck = {};
  final Map<String, Command> _waitingSuccess = {};
  final List<Command> _waitingInitQueue = [];

  Future<void> initSocket() async {
    if (_initLocked || _state == ConnectionState.none) return;
    _initLocked = true;
    await _initSocket();
  }

  Future<void> _initSocket() async {
    await dispose();
    _connectionAttempts++;
    _state = ConnectionState.waiting;

    final cookies = await PersistCookieJar(
      storage: FileStorage('${Globals.appDir.path}/.cookies'),
    ).loadForRequest(Uri.parse(Globals.restUrl));

    final res = await _connectToSocket(cookies);

    if (res.isLeft) {
      _initLocked = false;
      if (_connectionAttempts >= 5) {
        _state = ConnectionState.none;
        return;
      }
      _state = ConnectionState.done;
      Future.delayed(const Duration(milliseconds: 1000), initSocket);
      return;
    }

    final socket = res.right;

    _socket = IOWebSocketChannel(socket);
    _subscription = _socket!.stream.listen(
      _eventHandler,
      onError: (err) {
        debugPrint("onerror: $err");
      },
      onDone: reconnect,
    );
    _initLocked = false;
    _state = ConnectionState.active;
    _connectionAttempts = 0;

    // Reconnection for games which not ended yet
    _reconnectToAllGames();

    _recheckAllStatus();

    // Send waiting commands
    _waitingInitQueue.forEach(sendCommand);
    _waitingInitQueue.clear();
  }

  void reconnect() async {
    _state = ConnectionState.done;
    _connectionAttempts = 0;
    GetIt.I<PlayerStatusManager>().clearData();
    initSocket();
  }

  bool sendCommand(Command command) {
    if (_state != ConnectionState.active) {
      _waitingInitQueue.add(command);
      if (_state == ConnectionState.none) {
        initSocket();
      }
      return false;
    }
    _addToWaitingAck(command);

    final json = command.toMap();

    _socket!.sink.add(jsonEncode(json));
    return true;
  }

  void _reconnectToAllGames() {
    final games = GetIt.I<DBManager>().getAllNotEndedGames();
    for (var game in games) {
      final gameBoard = game.boardState.target!.board;
      sendCommand(
        ConnectToGameCommand(
          gameId: game.uid,
          successHandler: (data) {
            final newGameData = Game.fromJson(data!);
            // If board state is changed when we are not online, we need to
            // set notify to true
            final notify = gameBoard != newGameData.boardState.target!.board;
            newGameData.notify = notify;
            GetIt.I<DBManager>().putGame(newGameData);
          },
        ),
      );
    }
  }

  void _recheckAllStatus() {
    final nicks = GetIt.I<UserManager>().friends.value;
    sendCommand(CheckAllStatusCommand(
      nicks: nicks,
      successHandler: checkAllStatusesHandler,
    ));
  }

  void _eventHandler(dynamic event) {
    debugPrint(event);
    final data = Map.from(jsonDecode(event)).cast<String, dynamic>();
    switch (data["command"]) {
      case "ack":
        _addToWaitingSuccess(data["commandId"]);
        break;
      case "error":
        _handleError(data);
        break;
      case "success":
        _handleSuccess(data);
        break;
      case "playMove":
        final params = data["params"];
        playMoveHandler(params, true);
        break;
      case "connectToGame":
        final params = data["params"];
        _connectToGameHandler(params);
        break;
      case "statusUpdate":
        final params = data["params"];
        _statusUpdateHandler(params);
        break;
      case "gameRequest":
        final params = data["params"];
        _gameRequestHandler(params);
        break;
      case "endGame":
        final params = data["params"];
        _endGameHandler(params);
        break;
      case "drawOffer":
        final params = data["params"];
        drawOfferHandler(params);
        break;
      case "sendResponseToDrawOffer":
        final params = data["params"];
        sendResponseToDrawOfferHandler(params);
        break;
      case "resign":
        final params = data["params"];
        resignHandler(params);
        break;
      default:
    }
  }

  void _addToWaitingAck(Command command) {
    _waitingAck[command.commandId] = command;
  }

  void _addToWaitingSuccess(String commandId) {
    final value = _waitingAck.remove(commandId);
    if (value == null) return;
    _waitingSuccess[commandId] = value;
  }

  void _handleSuccess(Map<String, dynamic> data) {
    final command = _waitingSuccess.remove(data["commandId"]);

    if (command == null) return;

    command.successHandler?.call(data["params"]);
  }

  void _handleError(Map<String, dynamic> data) {
    final command = _waitingSuccess.remove(data["commandId"]);

    if (command == null) return;

    command.errorHandler?.call(data["params"]);
  }

  Future<void> dispose() async {
    await _socket?.sink.close(status.goingAway);
    await _subscription?.cancel();
  }
}

void _endGameHandler(dynamic params) {
  final gameId = params["gameId"];
  final reason = params["reason"];
  final result = params["result"];
  final game = GetIt.I<DBManager>().getGame(gameId);

  if (game == null) return;

  game.gameState = 4;
  game.notify = true;

  final white = game.white.target!;
  final black = game.black.target!;

  switch (reason) {
    case "firstmove":
      game.special = "cancelled";
      break;
    case "timeout":
      final who = result == "w" ? "white" : "black";
      game.special = "$who wins due to the timeout";
      switch (result) {
        case "w":
          game.winner = 0;
          white.timeLeft = 0;
          break;
        case "b":
          game.winner = 1;
          black.timeLeft = 0;
          break;
        default:
      }
      break;
    default:
  }
  GetIt.I<DBManager>().putGame(game);
  GetIt.I<DBManager>().putManyPlayerState([white, black]);
}

void _gameRequestHandler(dynamic params) {
  final request = GameRequest.fromJson(params);
  GetIt.I<GameRequestsManager>().addGameRequest(request);
}

void _statusUpdateHandler(dynamic params) {
  String nick = params["nick"];
  String status = params["status"];

  final friend = GetIt.I<PlayerStatusManager>().getPlayerStatus(nick);

  if (friend.status == status) return;
  friend.status = status;

  final adder = status == "online" ? 1 : -1;
  GetIt.I<PlayerStatusManager>().onlineCounter.value += adder;
}

void _connectToGameHandler(dynamic params) {
  final game = GetIt.I<DBManager>().getGame(params["gameId"]);

  if (game == null) return;

  final playerState = params["playerState"];

  if (playerState != null) {
    final ps = PlayerState.fromJson(playerState);
    game.white.target ??= ps;
    game.black.target ??= ps;
    game.gameState = 2;
  } else {
    //TODO: add observer to game
  }

  GetIt.I<DBManager>().putGame(game);
}

void checkAllStatusesHandler(dynamic params) {
  final statuses = List.from(params["statuses"]);
  final friends = statuses
      .map((e) => Player(nick: e["nick"], status: e["status"]))
      .toList();

  GetIt.I<PlayerStatusManager>().setPlayers(friends);
}

void playMoveHandler(dynamic params, [bool incoming = false]) {
  final game = GetIt.I<DBManager>().getGame(params["gameId"]);

  if (game == null) return;

  // Update game values
  final lastplayed = params["lastplayed"];
  game.lastPlayed = lastplayed;

  // If its black's first move
  if (game.gameState == 2 && game.boardState.target!.turn == 1) {
    game.gameState = 3;
  }

  final special = params["special"];
  if (special != null) {
    game.special = special;
    switch (special) {
      case "checkmate":
        game.winner = game.boardState.target!.turn;
        game.gameState = 4;
        break;
      case "stalemate":
        game.gameState = 4;
        break;
      default:
    }
  } else {
    game.special = null;
  }

  // That means you declined the draw request
  if (game.drawRequestFrom != null &&
      game.drawRequestFrom != GetIt.I<UserManager>().nick) {
    game.drawRequestFrom = null;
  }

  // If function is called from directly from socket, that means that move
  // is played by opponent. Otherwise, this was called from success handler
  // by means this is our move.
  game.notify = incoming;

  final move = params["move"];
  final bs = game.boardState.target!;
  final target = ChessCoord.fromString(move["target"]);
  final source = ChessCoord.fromString(move["source"]);
  String? promote = move["promote"];

  // Get current infos
  final board = bs.toBoard();
  final caslingRights = bs.toCastleSide();
  final enPassant =
      bs.enPassant == null ? null : ChessCoord.fromString(bs.enPassant!);
  final playerColor =
      game.playerColor == 0 ? PieceColor.white : PieceColor.black;

  final moveClass = MoveLogic(
    promote: promote,
    enPassant: enPassant,
    board: board,
    target: target,
    source: source,
    castlingRights: caslingRights,
    playerColor: playerColor,
  )..makeMove();

  // Update board state
  bs.updateBoard(moveClass.board);
  bs.updateCastleSide(moveClass.castlingRights);
  bs.enPassant = moveClass.enPassant?.toString();
  bs.turn = ++bs.turn % 2;

  // Update player states
  final white = PlayerState.fromJson(params["white"]);
  final black = PlayerState.fromJson(params["black"]);
  final oldWhite = game.white.target!;
  final oldBlack = game.black.target!;
  white.id = oldWhite.id;
  black.id = oldBlack.id;

  // Save changes to DB
  GetIt.I<DBManager>().putBoardState(bs);
  GetIt.I<DBManager>().putManyPlayerState([white, black]);
  GetIt.I<DBManager>().putGame(game);
}

void drawOfferHandler(dynamic params) {
  final game = GetIt.I<DBManager>().getGame(params["gameId"]);

  if (game == null) return;

  game.drawRequestFrom = params["from"];
  GetIt.I<DBManager>().putGame(game);
}

void sendResponseToDrawOfferHandler(dynamic params) {
  final game = GetIt.I<DBManager>().getGame(params["gameId"]);

  if (game == null) return;

  bool response = params["response"];

  game.drawRequestFrom = null;

  if (response) {
    game.gameState = 4;
    game.special = "draw";
    game.winner = 2;

    // Set active timer to current value
    final turn = game.boardState.target!.turn;

    final player = turn == 0 ? game.white.target! : game.black.target!;

    player.timeLeft = PlayerState.fromJson(params["playerState"]).timeLeft;

    GetIt.I<DBManager>().putPlayerState(player);
  }

  GetIt.I<DBManager>().putGame(game);
}

void resignHandler(dynamic params) {
  final game = GetIt.I<DBManager>().getGame(params["gameId"]);

  if (game == null) return;

  final who = params["who"];

  // Set active timer to current value
  final turn = game.boardState.target!.turn;
  final player = turn == 0 ? game.white.target! : game.black.target!;
  player.timeLeft = PlayerState.fromJson(params["playerState"]).timeLeft;

  GetIt.I<DBManager>().putPlayerState(player);

  if (game.white.target!.nick == who) {
    game.winner = 1;
    game.special = "white resigned";
  } else {
    game.winner = 0;
    game.special = "black resigned";
  }
  game.gameState = 4;
  GetIt.I<DBManager>().putGame(game);
}

Future<Either<Failure, WebSocket>> _connectToSocket(
    List<Cookie> cookies) async {
  try {
    final socket = await WebSocket.connect(
      Globals.wsUrl,
      headers: {
        'Cookie': cookies.join("; "),
      },
    );
    return Right(socket);
  } catch (e) {
    return const Left(Failure(
      key: FailureKey.socketConnectionError,
      message: "Couldn't connect to socket",
    ));
  }
}
