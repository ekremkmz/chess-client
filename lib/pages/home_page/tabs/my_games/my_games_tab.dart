import 'package:chess/data/websocket/commands/connect_to_game_command.dart';
import 'package:chess/data/websocket/socket_manager.dart';

import '../../../../logic/router/my_router_delagate.dart';
import 'delete_game_widget.dart';

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

class _MyGamesTabState extends State<MyGamesTab>
    with AutomaticKeepAliveClientMixin {
  late Stream<List<Game>> stream;

  @override
  void initState() {
    super.initState();
    stream = DBManager.instance.getAllGamesStream();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                onLongPress: () {
                  showGeneralDialog(
                    barrierLabel: "delete",
                    barrierDismissible: true,
                    context: context,
                    transitionBuilder: _transitionBuilder,
                    pageBuilder: (ctx, ani1, ani2) =>
                        _pageBuilder(ctx, ani1, ani2, game.id),
                    useRootNavigator: true,
                    transitionDuration: const Duration(milliseconds: 300),
                  );
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _pageBuilder(
    BuildContext context,
    Animation<double> ani1,
    Animation<double> ani2,
    int id,
  ) {
    return Center(
      child: Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(100, 8, 8, 8),
            child: DeleteGameWidget(
              id: id,
              animation: ani1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _transitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
          .animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
