import '../../data/local/db_manager.dart';
import '../../data/local/models/game.dart';
import '../../data/websocket/commands/create_new_game_command.dart';
import '../../data/websocket/socket_manager.dart';
import '../../dialogs/new_game_dialog.dart';
import 'tabs/my_friends_tab.dart';
import 'tabs/my_history_tab.dart';
import 'package:flutter/material.dart';

import 'tabs/my_games/my_games_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    SocketManager.instance.initSocket();
  }

  final _tabs = const [
    MyGamesTab(),
    MyFriendsTab(),
    MyHistoryTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog(
              context: context,
              builder: (context) {
                return const NewGameDialog();
              },
            );

            if (result == null) return;

            SocketManager.instance.sendCommand(CreateNewGameCommand(
              time: result["time"],
              add: result["add"],
              color: result["color"],
              successHandler: (data) {
                final game = Game.fromJson(data!);
                DBManager.instance.putGame(game);
              },
            ));
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Material(
              color: Colors.black,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                overlayColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.black;
                  }
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.grey;
                  }
                  return Colors.grey;
                }),
                unselectedLabelStyle: const TextStyle(
                  color: Colors.grey,
                ),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: "Games"),
                  Tab(text: "Friends"),
                  Tab(text: "History"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabs,
              ),
            )
          ],
        ),
      ),
    );
  }
}
