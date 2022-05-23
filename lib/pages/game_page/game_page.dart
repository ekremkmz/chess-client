import 'package:chess/logic/cubit/game_board_logic/game_board_logic_cubit.dart';
import 'package:chess/pages/game_page/player_state_widget.dart';
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
          children: [
            Flexible(
              child: PlayerStateWidget(playerState: cubit.opponent),
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
              child: PlayerStateWidget(playerState: cubit.you),
            ),
          ],
        ),
      ),
    );
  }
}
