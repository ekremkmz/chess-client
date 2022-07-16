import 'package:chess/logic/cubit/game_board_logic/chess_piece/king_piece.dart';

import '../../../../../data/local/models/game.dart';
import '../../../../../logic/cubit/game_board_logic/chess_piece/chess_piece.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MiniGameBoardWidget extends StatelessWidget {
  const MiniGameBoardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = context.watch<Game>();
    final bs = game.boardState.target!;
    final pl = bs.toBoard();
    final isWhite = game.playerColor == 0;

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
                  child: _buildChessCell(pl, i1, i2, isWhite, game),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChessCell(
      List<List<ChessPiece?>> board, int i1, int i2, bool isWhite, Game game) {
    final color =
        (i1 + i2) % 2 == 0 ? Colors.grey.shade300 : Colors.grey.shade600;
    final piece = board[i1][i2];
    final isCheckedKing = piece is KingPiece &&
        piece.color.index == game.boardState.target!.turn &&
        game.special != null &&
        game.special!.contains("check");

    return Container(
      decoration: BoxDecoration(
        color: color,
        gradient: isCheckedKing
            ? RadialGradient(
                colors: [
                  color,
                  const Color(0xFFFF6464),
                ],
              )
            : null,
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
