import 'dart:async';

import 'package:app_links/app_links.dart';
import '../../../data/runtime/friend_status_manager.dart';
import '../../../data/runtime/game_requests_manager.dart';
import 'package:get_it/get_it.dart';
import '../../../data/local/db_manager.dart';
import '../../../data/local/models/game.dart';
import '../../../data/websocket/commands/create_new_game_command.dart';
import '../../../data/websocket/socket_manager.dart';
import '../../../helper/app_link_handler.dart';
import '../../../logic/router/my_router_delagate.dart';
import '../../dialogs/new_game_dialog.dart';
import 'package:provider/provider.dart';
import 'tabs/my_friends/my_friends_tab.dart';
import 'tabs/my_requests/my_requests_tab.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _appLinks = AppLinks();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final router = context.read<MyRouterDelegate>();
      _appLinkStreamSubscription = _appLinks.uriLinkStream
          .listen((link) => appLinkHandler(link, router));

      final link = await _appLinks.getInitialAppLink();
      if (link == null) return;

      appLinkHandler(link, router);
    });

    GetIt.I<SocketManager>().initSocket();
  }

  final _tabs = const [
    MyGamesTab(),
    MyFriendsTab(),
    MyRequestsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (context) {
                return const NewGameDialog();
              },
            );

            if (result == null) return;

            GetIt.I<SocketManager>().sendCommand(CreateNewGameCommand(
              time: result["time"],
              add: result["add"],
              color: result["color"],
              successHandler: (data) {
                final game = Game.fromJson(data!);
                GetIt.I<DBManager>().putGame(game);
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
            GetIt.I<SocketManager>().reconnect();
          },
          child: Column(
            children: [
              _buildTabControllingArea(),
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

  Material _buildTabControllingArea() {
    return Material(
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: _buildTabController(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: "theme",
                  child: Text("Theme & Colors"),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case "theme":
                  context.read<MyRouterDelegate>().goToThemePage();
                  break;
                default:
              }
            },
          ),
        ],
      ),
    );
  }

  StreamBuilder<ConnectionState> _buildConnectionState() {
    return StreamBuilder<ConnectionState>(
      stream: GetIt.I<SocketManager>().connectionStateStream,
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

  Widget _buildTabController() {
    return TabBar(
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
      tabs: [
        Tab(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Games"),
                StreamBuilder<int>(
                  stream: GetIt.I<DBManager>().getPlayableGamesCountStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();
                    return snapshot.data != 0
                        ? _buildNotificationCounter("${snapshot.data!}")
                        : const SizedBox();
                  },
                )
              ],
            ),
          ),
        ),
        Tab(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Friends"),
                ValueListenableBuilder<int>(
                  valueListenable: GetIt.I<PlayerStatusManager>().onlineCounter,
                  builder: (context, value, _) {
                    return value > 0
                        ? _buildNotificationCounter("$value")
                        : const SizedBox();
                  },
                )
              ],
            ),
          ),
        ),
        Tab(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Game Requests"),
                ValueListenableBuilder<List>(
                  valueListenable: GetIt.I<GameRequestsManager>().gameRequests,
                  builder: (context, value, _) {
                    return value.isNotEmpty
                        ? _buildNotificationCounter("${value.length}")
                        : const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCounter(String value) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: Text(
        value,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    GetIt.I<SocketManager>().dispose();
    _tabController.dispose();
    _appLinkStreamSubscription?.cancel();
    super.dispose();
  }
}
