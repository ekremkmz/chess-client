import 'command.dart';

class ConnectToGameCommand extends Command {
  ConnectToGameCommand({
    required this.gameId,
    this.successHandler,
  });

  String gameId;

  @override
  SuccessHandlerCallback? successHandler;

  @override
  Map<String, dynamic> toMap() {
    return {
      "command": commandTag,
      "commandId": commandId,
      "params": {
        "gameId": gameId,
      },
    };
  }

  @override
  String get commandTag => "connectToGame";
}
