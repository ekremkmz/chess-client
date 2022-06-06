import '../../logic/cubit/game_board_logic/game_board_logic_cubit.dart';
import 'player_state_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_board_widget.dart';
import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GameBoardLogicCubit>();
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cubit.state is GameBoardLogicGaming
              ? _buildGame(cubit)
              : _buildLoading(),
        ),
      ),
    );
  }

  List<Widget> _buildGame(GameBoardLogicCubit cubit) {
    final state = (cubit.state as GameBoardLogicGaming);

    final isGameActive = state.gameState == 3;

    final opponent = cubit.opponent;
    final isOpponentWhite = state.whiteNick == opponent?.nick;
    final isWhitePlaying = state.turn == PieceColor.white;
    final isOpponentPlaying = isOpponentWhite == isWhitePlaying;

    return [
      Flexible(
        child: PlayerStateWidget(
          playerState: opponent,
          timerActive: isGameActive && isOpponentPlaying,
        ),
      ),
      Hero(
        tag: cubit.gameId,
        child: BlocProvider.value(
          value: cubit,
          child: const AspectRatio(
            aspectRatio: 1,
            child: GameBoardWidget(),
          ),
        ),
      ),
      Flexible(
        child: PlayerStateWidget(
          playerState: cubit.you,
          timerActive: isGameActive && !isOpponentPlaying,
        ),
      ),
    ];
  }

  List<Widget> _buildLoading() {
    return const [
      Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
    ];
  }
}
