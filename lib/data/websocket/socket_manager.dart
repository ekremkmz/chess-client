import 'dart:convert';
import 'dart:io';

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
      storage: FileStorage(Globals.appDir.path + '/.cookies'),
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
        //TODO: handle error
        break;
      case "success":
        _handleSuccess(data);
        break;
      case "playMove":
        final game = DBManager.instance.getGame("");

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
}
