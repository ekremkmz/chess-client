import 'package:chess/data/websocket/commands/command.dart';

class SendResponseToDrawOfferCommand extends Command {
  SendResponseToDrawOfferCommand({
    required this.gameId,
    required this.response,
    super.successHandler,
  });

  final String gameId;
  final bool response;

  @override
  String get commandTag => "sendResponseToDrawOffer";

  @override
  Map<String, dynamic> toMap() {
    return {
      "command": commandTag,
      "commandId": commandId,
      "params": {
        "gameId": gameId,
        "response": response,
      },
    };
  }
}
