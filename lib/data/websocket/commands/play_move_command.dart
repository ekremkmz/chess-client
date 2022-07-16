import 'command.dart';
import '../../../logic/cubit/game_board_logic/chess_coord.dart';

class PlayMoveCommand extends Command {
  final String? promote;
  final String gameId;
  final ChessCoord source;
  final ChessCoord target;

  PlayMoveCommand({
    this.promote,
    required this.gameId,
    required this.source,
    required this.target,
    super.successHandler,
  });

  @override
  String get commandTag => "playMove";

  @override
  Map<String, dynamic> toMap() {
    return {
      "command": commandTag,
      "commandId": commandId,
      "params": {
        "gameId": gameId,
        "source": source.toString(),
        "target": target.toString(),
        if (promote != null) "promote": promote!
      },
    };
  }
}
