import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'logic/router/my_router_delagate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _routerDelegate = MyRouterDelegate();

  final _backbuttonDispatcher = RootBackButtonDispatcher();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _routerDelegate,
      child: MaterialApp(
        title: 'Chess',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Router(
          routerDelegate: _routerDelegate,
          backButtonDispatcher: _backbuttonDispatcher,
        ),
      ),
    );
  }
}
