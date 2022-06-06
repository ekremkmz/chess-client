import '../../../../data/local/models/game.dart';
import '../../../../data/local/models/user.dart';
import '../../../../logic/cubit/game_board_logic/chess_piece/chess_piece.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MiniGameBoardWidget extends StatelessWidget {
  const MiniGameBoardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = context.read<Game>();
    final bs = game.boardState.target!;
    final pl = bs.toBoard();
    final isWhite = game.white.target?.nick == context.read<User>().nick;

    return RotatedBox(
      quarterTurns: isWhite ? 0 : 2,
      child: Column(
        children: List.generate(
          8,
          (i1) => Expanded(
            child: Row(
              children: List.generate(
                8,
                (i2) => Expanded(
                  child: _buildChessCell(pl, i1, i2, isWhite),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChessCell(
      List<List<ChessPiece?>> board, int i1, int i2, bool isWhite) {
    final color =
        (i1 + i2) % 2 == 0 ? Colors.grey.shade300 : Colors.grey.shade600;
    final piece = board[i1][i2];
    return Container(
      decoration: BoxDecoration(
        color: color,
      ),
      child: piece != null
          ? LayoutBuilder(
              builder: (context, constrains) {
                final image =
                    AssetImage("assets/images/pieces/${piece.toString()}.png");
                final size = constrains.maxWidth;

                return Center(
                  child: RotatedBox(
                    quarterTurns: isWhite ? 0 : 2,
                    child: Image(
                      image: image,
                      width: size / 4 * 3,
                      height: size / 4 * 3,
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
