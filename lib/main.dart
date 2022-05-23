import 'package:flutter/material.dart';

import 'logic/router/my_router_delagate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _routerDelegate = MyRouterDelegate();

  final _backbuttonDispatcher = RootBackButtonDispatcher();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Router(
        routerDelegate: _routerDelegate,
        backButtonDispatcher: _backbuttonDispatcher,
      ),
    );
  }
}
