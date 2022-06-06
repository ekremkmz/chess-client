import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../helper/app_link_handler.dart';
import '../../logic/router/my_router_delagate.dart';
import 'package:provider/provider.dart';

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

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _appLinkStreamSubscription;
  StreamSubscription<ConnectivityResult>? _connectivityStreamSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _appLinks = AppLinks();

    _connectivityStreamSubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      switch (result) {
        case ConnectivityResult.bluetooth:
          // TODO: Handle this case.
          break;
        case ConnectivityResult.wifi:
        case ConnectivityResult.mobile:
        case ConnectivityResult.none:
          // TODO: Handle this case.
          break;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final router = context.read<MyRouterDelegate>();
      _appLinkStreamSubscription = _appLinks.uriLinkStream
          .listen((link) => appLinkHandler(link, router));

      final link = await _appLinks.getInitialAppLink();
      if (link == null) return;

      appLinkHandler(link, router);
    });

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
        body: RefreshIndicator(
          notificationPredicate: (notification) {
            return notification.depth == 1;
          },
          onRefresh: () async {
            setState(() {
              SocketManager.instance.reconnect();
            });
          },
          child: Column(
            children: [
              _buildTabController(),
              _buildConnectionState(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _tabs,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<ConnectionState> _buildConnectionState() {
    return StreamBuilder<ConnectionState>(
      stream: SocketManager.instance.connectionStateStream,
      builder: (context, snapshot) {
        switch (snapshot.data) {
          case ConnectionState.active:
            return const SizedBox();

          case ConnectionState.done:
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Reconnecting..."),
              ),
            );
          case ConnectionState.none:
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Couldn't connect. Refresh to try again."),
              ),
            );

          case ConnectionState.waiting:
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Connecting..."),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  Material _buildTabController() {
    return Material(
      color: Colors.black,
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
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
    );
  }

  @override
  void dispose() {
    SocketManager.instance.dispose();
    _tabController.dispose();
    _appLinkStreamSubscription?.cancel();
    _connectivityStreamSubscription?.cancel();
    super.dispose();
  }
}
