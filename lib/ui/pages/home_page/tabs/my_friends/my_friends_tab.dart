import 'package:get_it/get_it.dart';

import '../../../../../data/runtime/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'friend_widget.dart';

class MyFriendsTab extends StatelessWidget {
  const MyFriendsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Builder(
          builder: (context) {
            return const SizedBox();
          },
        ),
        Expanded(
          child: ValueListenableBuilder<List<String>>(
            valueListenable: GetIt.I<UserManager>().friends,
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return FriendWidget(nick: value[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
