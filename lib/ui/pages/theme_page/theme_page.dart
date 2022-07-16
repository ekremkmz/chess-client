import 'package:chess/data/local/models/game.dart';
import 'package:chess/ui/pages/home_page/tabs/my_games/mini_game_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exampleGame = _getExampleGame();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Theme & Color'),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                exampleGame.special!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            AspectRatio(
              aspectRatio: 1.618, // hehe why not
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Provider.value(
                    value: exampleGame,
                    child: const MiniGameBoardWidget(),
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.black),
          ],
        ),
      ),
    );
  }

  Game _getExampleGame() => Game.fromJson({
        "adder": 0,
        "black": {"nick": "lives_matter", "timeleft": 300000},
        "white": {"nick": "lives_matter_too", "timeleft": 300000},
        "boardState": {
          "activeColor": 1,
          "board": "rnbqkbnr/3ppQpp/p7/1pp5/2B1P3/8/PPPP1PPP/RNB1K1NR",
          "castlingRights": ["K", "Q", "k", "q"],
          "enPassant": null,
          "fullMove": 0,
          "halfMove": 0
        },
        "gameId": "example",
        "state": 1,
        "timeControl": 5
      })
        ..playerColor = 0
        ..special = "checkmate";
}
