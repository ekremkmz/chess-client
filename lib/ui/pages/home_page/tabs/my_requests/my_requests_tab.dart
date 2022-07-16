import '../../../../../data/runtime/game_requests_manager.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../models/game_request.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'request_widget.dart';

class MyRequestsTab extends StatelessWidget {
  const MyRequestsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<GameRequest>>(
      valueListenable: GetIt.I<GameRequestsManager>().gameRequests,
      builder: (context, value, _) {
        return ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            return Provider.value(
              value: value[index],
              child: const RequestWidget(),
            );
          },
        );
      },
    );
  }
}
