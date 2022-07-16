import 'command.dart';

class DrawOfferCommand extends Command {
  DrawOfferCommand({
    required this.gameId,
    super.successHandler,
  });

  final String gameId;

  @override
  String get commandTag => "drawOffer";

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
