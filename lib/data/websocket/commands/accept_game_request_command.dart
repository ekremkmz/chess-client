import 'command.dart';

class AcceptGameRequestCommand extends Command {
  AcceptGameRequestCommand({
    required this.gameId,
    required this.senderCommandId,
    super.successHandler,
    super.errorHandler,
  });

  final String gameId;
  final String senderCommandId;

  @override
  String get commandTag => "acceptGameRequest";

  @override
  Map<String, dynamic> toMap() {
    return {
      "command": commandTag,
      "commandId": commandId,
      "params": {
        "gameId": gameId,
        "senderCommandId": senderCommandId,
      },
    };
  }
}
