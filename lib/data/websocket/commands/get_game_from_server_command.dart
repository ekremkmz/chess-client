import 'command.dart';

class GetGameFromServerCommand extends Command {
  GetGameFromServerCommand({
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
  String get commandTag => "getGame";
}
