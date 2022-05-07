import '../../../../data/local/models/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameWidget extends StatelessWidget {
  const GameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<Game>(context, listen: false);
    return Card(
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.red,
          ),
          Expanded(
            child: _buildGameDetails(game),
          ),
        ],
      ),
    );
  }

  Column _buildGameDetails(Game g) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              "assets/images/white_king.png",
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
              "assets/images/black_king.png",
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 10),
            Text(g.black.target?.nick ?? "?"),
          ],
        ),
      ],
    );
  }
}
