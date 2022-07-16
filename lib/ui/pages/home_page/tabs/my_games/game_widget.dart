import 'package:chess/ui/pages/game_page/countdown_widget.dart';
import 'package:chess/ui/pages/home_page/tabs/my_games/notify_background_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../data/local/models/game.dart';
import 'mini_game_board_widget.dart';

class GameWidget extends StatelessWidget {
  const GameWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = context.watch<Game>();
    final size = MediaQuery.of(context).size;

    final isGameOnFirstMove = game.gameState == 2;
    final isWhitePlaying = game.boardState.target!.turn == 0;

    Widget content = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          width: size.width / 3,
          height: size.width / 3,
          child: Hero(
            tag: game.uid,
            child: Provider.value(
              value: game,
              child: const MiniGameBoardWidget(),
            ),
          ),
        ),
        Expanded(
          child: _buildGameDetails(game),
        ),
      ],
    );
    if (isGameOnFirstMove) {
      content = Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CountDownWidget(
              from: Duration(
                milliseconds:
                    isWhitePlaying ? game.createdAt! : game.lastPlayed!,
              ),
              duration: const Duration(seconds: 30),
            ),
          ),
          content,
        ],
      );
    }
    if (game.notify) {
      content = Stack(
        children: [
          const Positioned.fill(
            child: NotifyBackgroundWidget(
              duration: Duration(seconds: 1),
            ),
          ),
          content,
        ],
      );
    }
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 10,
      child: content,
    );
  }

  Widget _buildGameDetails(Game g) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(g.white.target?.nick ?? "?"),
              const SizedBox(width: 10),
              Image.asset(
                "assets/images/pieces/white_king.png",
                width: 30,
                height: 30,
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(g.black.target?.nick ?? "?"),
              const SizedBox(width: 10),
              Image.asset(
                "assets/images/pieces/black_king.png",
                width: 30,
                height: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
