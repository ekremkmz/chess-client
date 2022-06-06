import '../home_page/tabs/my_games/mini_game_board_widget.dart';
import 'package:provider/provider.dart';

import '../../logic/cubit/game_board_logic/chess_coord.dart';
import '../../logic/cubit/game_board_logic/game_board_logic_cubit.dart';
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
      //TODO:ayarlarsın işte
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
                    child: _buildDragTarget(cubit, i1, i2, isWhite),
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
      GameBoardLogicCubit cubit, int i1, int i2, bool isWhite) {
    final state = cubit.state as GameBoardLogicGaming;
    final target = ChessCoord(row: i1, column: i2);

    return DragTarget<ChessCoord>(
      onAccept: (data) {
        cubit.move(data, target);
      },
      onWillAccept: (data) {
        if (data! == target) return false;
        if (state.movableLocations == null) return false;
        if (!state.movableLocations![target.row][target.column]) return false;
        final canMove = cubit.canMove(data, target);
        return canMove;
      },
      builder: (context, candidateData, rejectedData) {
        final piece = state.board[i1][i2];
        final color =
            (i1 + i2) % 2 == 0 ? Colors.grey.shade300 : Colors.grey.shade600;
        final ml = state.movableLocations;
        final board = state.board;
        return Container(
          decoration: BoxDecoration(
            color: color,
            gradient: ml == null
                ? null
                : ml[i1][i2] && board[i1][i2] != null
                    ? RadialGradient(
                        colors: [
                          color,
                          const Color(0xFF81C784),
                        ],
                      )
                    : null,
          ),
          child: piece != null
              ? RotatedBox(
                  quarterTurns: isWhite ? 0 : 2,
                  child: ChessPieceWidget(
                    piece: piece,
                    coord: target,
                  ),
                )
              : ml == null
                  ? null
                  : ml[i1][i2]
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
