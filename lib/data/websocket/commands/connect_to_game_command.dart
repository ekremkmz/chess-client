import 'command.dart';

class ConnectToGameCommand extends Command {
  ConnectToGameCommand({
    required this.gameId,
    super.successHandler,
  });

  String gameId;

  @override
  String get commandTag => "connectToGame";

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
}
