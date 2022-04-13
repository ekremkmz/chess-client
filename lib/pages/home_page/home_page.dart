import 'package:chess/pages/home_page/tabs/my_friends_tab.dart';
import 'package:chess/pages/home_page/tabs/my_games_tab.dart';
import 'package:chess/pages/home_page/tabs/my_history_tab.dart';
import 'package:flutter/material.dart';

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
  }

  final _tabs = const [
    MyGamesTab(),
    MyFriendsTab(),
    MyHistoryTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            color: Colors.black,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.pressed)) return Colors.black;
                if (states.contains(MaterialState.hovered)) return Colors.grey;
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
    );
  }
}
