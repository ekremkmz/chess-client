import 'package:chess/logic/cubit/game_board_logic/chess_piece/king_piece.dart';
import 'package:chess/logic/cubit/game_board_logic/chess_piece/pawn_piece.dart';
import 'package:chess/ui/dialogs/pawn_promote_dialog.dart';

import '../../../logic/cubit/game_board_logic/piece_color.dart';

import '../../../logic/cubit/game_board_logic/chess_coord.dart';
import '../../../logic/cubit/game_board_logic/game_board_logic_cubit.dart';

import '../home_page/tabs/my_games/mini_game_board_widget.dart';
import 'package:provider/provider.dart';

import 'chess_piece_widget.dart';
import 'package:flutter/material.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GameBoardLogicCubit>();
    final state = cubit.state;
    final isWhite = cubit.playerColor == PieceColor.white;

    if (state is GameBoardLogicInitial) {
      //TODO: ayarlarsın işte
      return Provider.value(
        value: cubit.game,
        child: cubit.game != null
            ? const MiniGameBoardWidget()
            : _buildWaitingForGame(),
      );
    }

    if (state is GameBoardLogicGaming) {
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
                    child: _buildDragTarget(cubit, i1, i2, isWhite, context),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return const Text("Error");
  }

  Widget _buildDragTarget(
    GameBoardLogicCubit cubit,
    int i1,
    int i2,
    bool isWhite,
    BuildContext context,
  ) {
    final state = cubit.state as GameBoardLogicGaming;
    final target = ChessCoord(row: i1, column: i2);

    return DragTarget<ChessCoord>(
      onAccept: (data) async {
        final piece = state.board[data.row][data.column]!;
        String? promote;
        if (piece is PawnPiece && [0, 7].contains(target.row)) {
          promote = await showDialog<String>(
            barrierDismissible: true,
            useRootNavigator: true,
            context: context,
            builder: (_) => PawnPromoteDialog(color: piece.color),
          );
          if (promote == null) return;
        }
        cubit.move(data, target, promote);
      },
      onWillAccept: (data) {
        if (data! == target) return false;
        if (state.movableLocations == null) return false;
        if (!state.movableLocations![target.row][target.column]) return false;
        final canMove = cubit.canMove(data, target);
        return canMove;
      },
      builder: (context, _, __) {
        final piece = state.board[i1][i2];
        final color =
            (i1 + i2) % 2 == 0 ? Colors.grey.shade300 : Colors.grey.shade600;
        final ml = state.movableLocations;
        final isMovableLoc = ml != null && ml[i1][i2];
        final hasPiece = piece != null;
        final isCapturable = isMovableLoc && hasPiece;
        final isCheckedKing = piece is KingPiece &&
            piece.color == state.turn &&
            state.special != null &&
            state.special!.contains("check");
        return Container(
          decoration: BoxDecoration(
            color: color,
            gradient: isCapturable
                ? RadialGradient(
                    colors: [
                      color,
                      const Color(0xFF81C784),
                    ],
                  )
                : isCheckedKing
                    ? RadialGradient(
                        colors: [
                          color,
                          const Color(0xFFFF6464),
                        ],
                      )
                    : null,
          ),
          child: hasPiece
              ? RotatedBox(
                  quarterTurns: isWhite ? 0 : 2,
                  child: ChessPieceWidget(
                    piece: piece,
                    coord: target,
                  ),
                )
              : isMovableLoc
                  ? const Center(
                      child: FractionallySizedBox(
                        heightFactor: 0.25,
                        widthFactor: 0.25,
                        child: Material(
                          color: Colors.green,
                          shape: CircleBorder(),
                        ),
                      ),
                    )
                  : null,
        );
      },
    );
  }

  Widget _buildWaitingForGame() {
    return AspectRatio(
      aspectRatio: 1,
      child: Expanded(
        child: Container(),
      ),
    );
  }
}
