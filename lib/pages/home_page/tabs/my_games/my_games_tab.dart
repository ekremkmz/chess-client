import '../../../../data/local/db_manager.dart';
import '../../../../data/local/models/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_widget.dart';

class MyGamesTab extends StatelessWidget {
  const MyGamesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Game>>(
      stream: DBManager.instance.getAllGamesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final game = snapshot.data![index];
              return Provider.value(
                value: game,
                child: const GameWidget(),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
