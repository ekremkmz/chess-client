import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chess/logic/cubit/game_board_logic/chess_coord.dart';

import '../local/db_manager.dart';
import '../globals.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'commands/command.dart';

class SocketManager {
  SocketManager._();
  static SocketManager? _instance;
  late WebSocket socket;

  static SocketManager get instance {
    _instance ??= SocketManager._();
    return _instance!;
  }

  Map<String, Command> waitingAck = {};
  Map<String, Command> waitingSuccess = {};

  void initSocket() async {
    final cookies = await PersistCookieJar(
      storage: FileStorage('${Globals.appDir.path}/.cookies'),
    ).loadForRequest(Uri.parse(Globals.restUrl));
    instance.socket = await WebSocket.connect(Globals.wsUrl, headers: {
      'Cookie': cookies.join("; "),
    });
    instance.socket.asBroadcastStream().listen(_eventHandler);
  }

  void sendCommand(Command command) {
    _addToWaitingAck(command);

    final json = command.toMap();

    socket.add(jsonEncode(json));
  }

  void _eventHandler(dynamic event) {
    print(event);
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
        final target = ChessCoord.fromString(params["target"]);
        final source = ChessCoord.fromString(params["source"]);

        final game = DBManager.instance.getGame(params["gameId"])!;

        final board = game.boardState.target!.toBoard();

        board[target.row][target.column] = board[source.row][source.column];
        board[source.row][source.column] = null;
        board[target.row][target.column]!.move(target);
        game.boardState.target!.updateBoard(board);

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
}
