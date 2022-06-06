import 'mini_game_board_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../data/local/models/game.dart';
import 'package:flutter/material.dart';

class GameWidget extends StatelessWidget {
  const GameWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = context.watch<Game>();
    final size = MediaQuery.of(context).size;
    return Card(
      child: Row(
        children: [
          SizedBox(
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
      ),
    );
  }

  Widget _buildGameDetails(Game g) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/pieces/white_king.png",
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 10),
              Text(g.white.target?.nick ?? "?"),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Image.asset(
                "assets/images/pieces/black_king.png",
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 10),
              Text(g.black.target?.nick ?? "?"),
            ],
          ),
        ],
      ),
    );
  }
}
