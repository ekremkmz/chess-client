import 'package:chess/data/local/models/player_state.dart';
import 'package:flutter/material.dart';

import 'timer_widget.dart';

class PlayerStateWidget extends StatelessWidget {
  const PlayerStateWidget({
    this.playerState,
    Key? key,
  }) : super(key: key);

  final PlayerState? playerState;

  @override
  Widget build(BuildContext context) {
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
              child: TimerWidget(time: playerState?.timeLeft ?? 0),
            ),
          ],
        ),
      ),
    );
  }
}
