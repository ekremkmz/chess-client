import 'package:chess/data/runtime/user_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../../../logic/cubit/game_board_logic/piece_color.dart';

import '../../../logic/cubit/game_board_logic/game_board_logic_cubit.dart';

import 'countdown_widget.dart';
import 'player_state_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_board_widget.dart';
import 'package:flutter/material.dart';

import 'confirmable_button_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    Key? key,
  }) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late final _resignController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final _offerDrawController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GameBoardLogicCubit>();
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildGame(cubit),
        ),
        bottomNavigationBar: cubit.game!.gameState == 3
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _buildCommandButtons(cubit),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  List<Widget> _buildGame(GameBoardLogicCubit cubit) {
    final state = (cubit.state as GameBoardLogicGaming);

    final isGameOnFirstMove = state.gameState == 2;
    final isGameActive = state.gameState == 3;
    final isGameEnded = state.gameState == 4;

    final opponent = cubit.opponent;
    final isOpponentWhite = state.whiteNick == opponent?.nick;
    final isWhitePlaying = state.turn == PieceColor.white;
    final isOpponentPlaying = isOpponentWhite == isWhitePlaying;

    return [
      if (isGameEnded)
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            state.special!.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      if (isGameOnFirstMove)
        CountDownWidget(
          from: Duration(
            milliseconds: isWhitePlaying
                ? cubit.game!.createdAt!
                : cubit.game!.lastPlayed!,
          ),
          duration: const Duration(seconds: 30),
        ),
      Flexible(
        child: PlayerStateWidget(
          playerState: opponent,
          timerActive: isGameActive && isOpponentPlaying,
        ),
      ),
      Card(
        elevation: 12,
        clipBehavior: Clip.hardEdge,
        child: Hero(
          tag: cubit.gameId,
          child: BlocProvider.value(
            value: cubit,
            child: const AspectRatio(
              aspectRatio: 1,
              child: GameBoardWidget(),
            ),
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

  List<Widget> _buildCommandButtons(GameBoardLogicCubit cubit) {
    final from = cubit.game!.drawRequestFrom;
    final nickName = GetIt.I<UserManager>().nick;
    final isDrawOfferedFromMe = from == nickName;
    final isDrawOffered = from != null;
    return [
      ConfirmableButton(
        waitingConfirmation: isDrawOffered,
        enabled: !isDrawOfferedFromMe,
        onWaitingConfirm: () {
          _offerDrawController.repeat();
        },
        onConfirm: isDrawOffered ? cubit.acceptDrawOffer : cubit.offerDraw,
        onDecline: () {
          _offerDrawController.stop();
          _offerDrawController.reset();
          if (isDrawOffered && !isDrawOfferedFromMe) {
            cubit.declineDrawOffer();
          }
        },
        child: LottieBuilder.asset(
          'assets/lottie/draw_request_lottie.json',
          controller: _offerDrawController,
          delegates: LottieDelegates(
            values: [
              ValueDelegate.color(
                ["**", "Fill 1"],
                value: Colors.white,
              )
            ],
          ),
        ),
      ),
      ConfirmableButton(
        onWaitingConfirm: () {
          _resignController.repeat();
        },
        onConfirm: () {
          cubit.resign();
        },
        onDecline: () {
          _resignController.stop();
          _resignController.reset();
        },
        child: LottieBuilder.asset(
          'assets/lottie/resign_lottie.json',
          controller: _resignController,
          delegates: LottieDelegates(
            values: [
              ValueDelegate.color(
                ["**", "Fill 1"],
                value: Colors.white,
              ),
              ValueDelegate.strokeColor(
                ["**"],
                value: Colors.white,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  void dispose() {
    _resignController.dispose();
    _offerDrawController.dispose();
    super.dispose();
  }
}
