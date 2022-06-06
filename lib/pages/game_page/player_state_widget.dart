import 'package:chess/logic/cubit/game_board_logic/game_board_logic_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local/models/player_state.dart';
import 'package:flutter/material.dart';

import 'timer_widget.dart';

class PlayerStateWidget extends StatelessWidget {
  const PlayerStateWidget({
    this.playerState,
    Key? key,
    required this.timerActive,
  }) : super(key: key);

  final PlayerState? playerState;

  final bool timerActive;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameBoardLogicCubit>();
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Container(
        color: Colors.black,
        child: Row(
          children: [
            Flexible(
              child: Center(
                child: Text(
                  playerState?.nick ?? "?",
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            Flexible(
              child: TimerWidget(
                active: timerActive,
                lastPlayed: cubit.game!.lastPlayed,
                time: playerState?.timeLeft ?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
