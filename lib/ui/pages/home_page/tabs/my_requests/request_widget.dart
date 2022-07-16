import 'package:chess/logic/router/my_router_delagate.dart';

import '../../../../../data/local/db_manager.dart';
import '../../../../../data/local/models/game.dart';

import '../../../../../data/runtime/game_requests_manager.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../data/websocket/commands/accept_game_request_command.dart';
import '../../../../../../data/websocket/socket_manager.dart';
import '../../../../../../models/game_request.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestWidget extends StatefulWidget {
  const RequestWidget({Key? key}) : super(key: key);

  @override
  State<RequestWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
  final valueListenable = ValueNotifier(RequestState.stays);
  @override
  Widget build(BuildContext context) {
    final request = context.read<GameRequest>();
    return Card(
      child: ListTile(
        title: Text(request.nick),
        subtitle: Text("${request.time} + ${request.add}"),
        trailing: _buildAcceptButton(request),
      ),
    );
  }

  IconButton _buildAcceptButton(GameRequest request) {
    return IconButton(
      icon: ValueListenableBuilder<RequestState>(
        valueListenable: valueListenable,
        builder: (context, state, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            constraints: state == RequestState.waits
                ? const BoxConstraints(maxHeight: 20, maxWidth: 20)
                : const BoxConstraints(maxHeight: 30, maxWidth: 30),
            alignment: Alignment.center,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: state == RequestState.waits ? 0.5 : 1.0,
              child: child,
            ),
          );
        },
        child: const FittedBox(
          child: Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ),
      ),
      onPressed: () {
        if (valueListenable.value != RequestState.stays) return;
        valueListenable.value = RequestState.waits;
        // We are getting [ScaffoldMessenger] and [MyRouterDelegate] from here
        // because maybe context could be destroyed later
        final messenger = ScaffoldMessenger.of(context);
        final router = context.read<MyRouterDelegate>();
        GetIt.I<SocketManager>().sendCommand(AcceptGameRequestCommand(
          gameId: request.gameId,
          senderCommandId: request.senderCommandId,
          successHandler: (data) {
            valueListenable.value = RequestState.accepted;
            final value = GetIt.I<GameRequestsManager>().gameRequests.value;
            GetIt.I<GameRequestsManager>().gameRequests.value = List.from(value)
              ..remove(request);
            final game = Game.fromJson(data);
            game.id = GetIt.I<DBManager>().putGame(game);
            router.goToGamePage(game.uid, game);
          },
          errorHandler: (data) {
            final value = GetIt.I<GameRequestsManager>().gameRequests.value;
            GetIt.I<GameRequestsManager>().gameRequests.value = List.from(value)
              ..remove(request);
            messenger.showSnackBar(
              SnackBar(content: Text(data.toString())),
            );
          },
        ));
      },
    );
  }
}

enum RequestState {
  stays,
  waits,
  accepted,
}
