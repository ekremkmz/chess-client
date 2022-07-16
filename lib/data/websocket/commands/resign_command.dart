import 'package:chess/data/websocket/commands/command.dart';

class ResignCommand extends Command {
  ResignCommand({
    required this.gameId,
    super.successHandler,
  });

  final String gameId;

  @override
  String get commandTag => "resign";

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
