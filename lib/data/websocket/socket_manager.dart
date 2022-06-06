import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chess/data/local/models/game.dart';
import 'package:chess/data/local/models/player_state.dart';

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
  SocketManager._();
  static SocketManager? _instance;

  static SocketManager get instance {
    _instance ??= SocketManager._();
    return _instance!;
  }

  final StreamController<ConnectionState> _connectionStateController =
      StreamController()..add(ConnectionState.none);

  Stream<ConnectionState> get connectionStateStream =>
      _connectionStateController.stream;

  ConnectionState _connectionState = ConnectionState.none;

  ConnectionState get _state => _connectionState;
  set _state(ConnectionState state) {
    _connectionState = state;
    _connectionStateController.add(state);
  }

  IOWebSocketChannel? _socket;
  StreamSubscription<dynamic>? _subscription;

  bool _initLocked = false;
  int connectionAttempts = 0;
  Map<String, Command> waitingAck = {};
  Map<String, Command> waitingSuccess = {};
  List<Command> waitingInitQueue = [];

  Future<void> initSocket() async {
    if (_initLocked) return;
    _initLocked = true;
    await _initSocket();
  }

  Future<void> _initSocket() async {
    await dispose();
    connectionAttempts++;
    _state = ConnectionState.waiting;

    final cookies = await PersistCookieJar(
      storage: FileStorage('${Globals.appDir.path}/.cookies'),
    ).loadForRequest(Uri.parse(Globals.restUrl));

    final res = await _connectToSocket(cookies);

    if (res.isLeft) {
      _initLocked = false;
      if (connectionAttempts >= 5) {
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
    connectionAttempts = 0;

    // Reconnection for games which not ended yet
    reconnectToAllGames();

    // Send waiting commands
    waitingInitQueue.forEach(sendCommand);
    waitingInitQueue.clear();
  }

  void reconnect() async {
    connectionAttempts = 0;
    initSocket();
  }

  bool sendCommand(Command command) {
    if (_state != ConnectionState.active) {
      waitingInitQueue.add(command);
      return false;
    }
    _addToWaitingAck(command);

    final json = command.toMap();

    _socket!.sink.add(jsonEncode(json));
    return true;
  }

  void reconnectToAllGames() {
    final games = DBManager.instance.getAllNotEndedGames();
    for (var game in games) {
      SocketManager.instance.sendCommand(
        ConnectToGameCommand(
          gameId: game.uid,
          successHandler: (data) {
            final newGameData = Game.fromJson(data!);
            DBManager.instance.putGame(newGameData);
          },
        ),
      );
    }
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
        final params = data["data"];
        playMoveHandler(params);
        break;
      case "connectToGame":
        final params = data["data"];

        final game = DBManager.instance.getGame(params["gameId"])!;

        final playerState = params["playerState"];

        if (playerState != null) {
          final ps = PlayerState.fromJson(playerState);
          game.white.target ??= ps;
          game.black.target ??= ps;
          game.gameState = 2;
        } else {
          //TODO:add observer to game
        }

        DBManager.instance.putGame(game);
        break;
      default:
    }
  }

  void _addToWaitingAck(Command command) {
    waitingAck[command.commandId] = command;
  }

  void _addToWaitingSuccess(String commandId) {
    final value = waitingAck.remove(commandId);
    if (value == null) return;
    waitingSuccess[commandId] = value;
  }

  void _handleSuccess(Map<String, dynamic> data) {
    final command = waitingSuccess.remove(data["commandId"]);

    if (command == null) return;

    command.successHandler?.call(data["data"]);
  }

  void _handleError(Map<String, dynamic> data) {
    waitingSuccess.remove(data["commandId"]);

    log(data["data"]);
  }

  Future<void> dispose() async {
    await _socket?.sink.close(status.goingAway);
    await _subscription?.cancel();
  }
}

void playMoveHandler(dynamic params) {
  final move = params["move"];
  final lastplayed = params["lastplayed"];
  final target = ChessCoord.fromString(move["target"]);
  final source = ChessCoord.fromString(move["source"]);

  final game = DBManager.instance.getGame(params["gameId"])!;

  // If its first move
  if (game.gameState == 2) {
    game.gameState = 3;
  }
  game.lastPlayed = lastplayed;
  final bs = game.boardState.target!;
  final board = bs.toBoard();

  board[target.row][target.column] = board[source.row][source.column];
  board[source.row][source.column] = null;
  board[target.row][target.column]!.move(target);

  bs.updateBoard(board);

  bs.turn = ++bs.turn % 2;

  DBManager.instance.putBoardState(bs);

  final ps = PlayerState.fromJson(params["playerState"]);

  if (game.black.target!.nick == ps.nick) {
    final black = game.black.target!;
    black.timeLeft = ps.timeLeft;
    DBManager.instance.putPlayerState(black);
  } else if (game.white.target!.nick == ps.nick) {
    final white = game.white.target!;
    white.timeLeft = ps.timeLeft;
    DBManager.instance.putPlayerState(white);
  }

  DBManager.instance.putGame(game);
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
    //TODO: uncomment for latency detection
    //..pingInterval = const Duration(seconds: 5);
    return Right(socket);
  } catch (e) {
    return const Left(Failure(
      key: FailureKey.socketConnectionError,
      message: "Couldn't connect to socket",
    ));
  }
}
