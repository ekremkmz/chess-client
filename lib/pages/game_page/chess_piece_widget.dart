import '../../logic/cubit/game_board_logic/chess_coord.dart';
import '../../logic/cubit/game_board_logic/chess_piece/chess_piece.dart';
import '../../logic/cubit/game_board_logic/game_board_logic_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChessPieceWidget extends StatelessWidget {
  const ChessPieceWidget({
    required this.piece,
    required this.coord,
    Key? key,
  }) : super(key: key);

  final ChessPiece piece;

  final ChessCoord coord;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameBoardLogicCubit>();

    final isPieceMine = cubit.playerColor! == piece.color;

    return LayoutBuilder(
      builder: (context, constrains) {
        final image =
            AssetImage("assets/images/pieces/${piece.toString()}.png");
        final size = constrains.maxWidth;

        final imageWidget = Image(
          image: image,
          width: size / 4 * 3,
          height: size / 4 * 3,
        );

        return Center(
          child: isPieceMine
              ? Draggable<ChessCoord>(
                  onDragStarted: () => cubit.showMovableLocations(coord),
                  child: GestureDetector(
                    onTap: () => cubit.showMovableLocations(coord),
                    child: imageWidget,
                  ),
                  onDragEnd: (details) {
                    cubit.hideMovableLocations();
                  },
                  childWhenDragging: Opacity(
                    opacity: 0.2,
                    child: imageWidget,
                  ),
                  feedback: Image(
                    image: image,
                    width: size,
                    height: size,
                  ),
                  data: coord,
                )
              : imageWidget,
        );
      },
    );
  }
}
