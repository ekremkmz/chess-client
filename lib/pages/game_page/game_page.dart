import 'game_board_widget.dart';
import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  const GamePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOpponent(),
            _buildGameBoard(),
            _buildYou(),
          ],
        ),
      ),
    );
  }

  Widget _buildOpponent() {
    return Container();
  }

  Widget _buildGameBoard() {
    return const GameBoardWidget();
  }

  Widget _buildYou() {
    return Container();
  }
}
