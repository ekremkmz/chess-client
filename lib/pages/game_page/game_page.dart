import 'package:chess/logic/cubit/game_board_logic/game_board_logic_cubit.dart';
import 'package:chess/pages/game_page/game_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

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
    return BlocProvider(
      create: (context) => GameBoardLogicCubit(),
      child: const GameBoardWidget(),
    );
  }

  Widget _buildYou() {
    return Container();
  }
}
