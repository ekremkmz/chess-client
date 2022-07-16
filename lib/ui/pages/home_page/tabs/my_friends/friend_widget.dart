import '../../../../../data/runtime/friend_status_manager.dart';
import 'package:get_it/get_it.dart';

import '../../../../dialogs/new_game_dialog.dart';

import '../../../../../../data/local/db_manager.dart';
import '../../../../../../data/local/models/game.dart';
import '../../../../../../data/websocket/commands/create_new_game_command.dart';
import '../../../../../../data/websocket/socket_manager.dart';
import '../../../../../../models/friend.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FriendWidget extends StatefulWidget {
  const FriendWidget({Key? key, required this.nick}) : super(key: key);

  final String nick;

  @override
  State<FriendWidget> createState() => _FriendWidgetState();
}

class _FriendWidgetState extends State<FriendWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Player friend;
  bool tapTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    friend = GetIt.I<PlayerStatusManager>().getPlayerStatus(widget.nick);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AnimatedBuilder(
        animation: friend,
        builder: (context, _) {
          return ListTile(
            title: Text(friend.nick),
            subtitle: Text(friend.status),
            trailing: friend.status == "online"
                ? GestureDetector(
                    child: Lottie.asset(
                      'assets/lottie/battle_lottie.json',
                      controller: _controller,
                    ),
                    onTap: () async {
                      if (tapTriggered) return;
                      tapTriggered = true;
                      await _controller.forward();
                      _controller.reset();
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (context) {
                          return const NewGameDialog();
                        },
                      );
                      tapTriggered = false;
                      if (result == null) return;

                      GetIt.I<SocketManager>().sendCommand(CreateNewGameCommand(
                        time: result["time"],
                        add: result["add"],
                        color: result["color"],
                        friend: friend.nick,
                        successHandler: (data) {
                          final game = Game.fromJson(data!);
                          GetIt.I<DBManager>().putGame(game);
                        },
                      ));
                    },
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
