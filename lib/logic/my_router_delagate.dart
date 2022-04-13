import 'package:chess/pages/game_page/game_page.dart';
import 'package:chess/pages/login_page.dart';
import 'package:chess/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();

  final _heroController = HeroController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this,
      child: Navigator(
        key: _navigatorKey,
        observers: [_heroController],
        pages: [
          MaterialPage(
            child: LoginPage(),
          ),
          MaterialPage(
            child: HomePage(),
          ),
          MaterialPage(
            child: GamePage(),
          ),
        ],
        onPopPage: (route, result) {
          if (route.didPop(result)) return false;
          return true;
        },
      ),
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }

  void goToRegisterPage() {}

  void goToLogin() {}

  void goToHomePage() {}
}
