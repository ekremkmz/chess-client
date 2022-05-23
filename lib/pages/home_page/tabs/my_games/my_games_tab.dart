import 'package:chess/logic/router/my_router_delagate.dart';

import '../../../../data/local/db_manager.dart';
import '../../../../data/local/models/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_widget.dart';

class MyGamesTab extends StatefulWidget {
  const MyGamesTab({Key? key}) : super(key: key);

  @override
  State<MyGamesTab> createState() => _MyGamesTabState();
}

class _MyGamesTabState extends State<MyGamesTab> {
  late Stream<List<Game>> stream;

  @override
  void initState() {
    super.initState();
    stream = DBManager.instance.getAllGamesStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Game>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final game = snapshot.data![index];
              return GestureDetector(
                child: Provider.value(
                  value: game,
                  child: const GameWidget(),
                ),
                onTap: () {
                  context.read<MyRouterDelegate>().goToGamePage(game.uid, game);
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
