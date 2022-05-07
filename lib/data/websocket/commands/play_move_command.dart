import 'package:chess/data/websocket/commands/command.dart';
import 'package:chess/logic/cubit/game_board_logic/chess_coord.dart';

class PlayMoveCommand extends Command {
  final ChessCoord source;
  final ChessCoord target;

  PlayMoveCommand({
    required this.source,
    required this.target,
    this.successHandler,
  });

  @override
  String get commandTag => "playMove";

  @override
  SuccessHandlerCallback? successHandler;

  @override
  Map<String, dynamic> toMap() {
    return {
      "command": commandTag,
      "commandId": commandId,
      "params": {
        "source": source,
        "target": target,
      },
    };
  }
}
