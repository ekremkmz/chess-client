import 'command.dart';
import '../../../logic/cubit/game_board_logic/chess_coord.dart';

class PlayMoveCommand extends Command {
  final String gameId;
  final ChessCoord source;
  final ChessCoord target;

  PlayMoveCommand({
    required this.gameId,
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
        "gameId": gameId,
        "source": source.toString(),
        "target": target.toString(),
      },
    };
  }
}
