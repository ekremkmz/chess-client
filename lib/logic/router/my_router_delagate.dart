import 'package:chess/ui/pages/theme_page/theme_page.dart';
import 'package:get_it/get_it.dart';

import '../../ui/pages/auth/login_page.dart';
import '../../ui/pages/game_page/game_page.dart';
import '../../ui/pages/home_page/home_page.dart';
import '../../ui/pages/splash_screen.dart';

import '../../data/local/models/game.dart';
import '../../data/runtime/user_manager.dart';
import '../cubit/game_board_logic/game_board_logic_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();

  final _heroController = HeroController();

  bool _isInitialized = false;

  Game? _game;

  String? _gameId;

  bool _isOnThemePage = false;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      observers: [_heroController],
      pages: [
        if (!_isInitialized)
          const MaterialPage(
            key: ValueKey("/splash"),
            child: SplashScreen(),
          )
        else if (!GetIt.I.isRegistered<UserManager>())
          MaterialPage(
            key: const ValueKey("/login"),
            child: LoginPage(),
          )
        else
          const MaterialPage(
            key: ValueKey("/home"),
            child: HomePage(),
          ),
        // Initialization is needed anyway because maybe we clicked a
        // notification that lands us the game page
        if (_gameId != null && _isInitialized)
          MaterialPage(
            key: ValueKey("/game$_game"),
            child: BlocProvider(
              create: (context) => GameBoardLogicCubit(
                game: _game,
                gameId: _gameId!,
                userNick: GetIt.I<UserManager>().nick,
              ),
              child: const GamePage(),
            ),
          ),
        if (_isOnThemePage)
          const MaterialPage(
            key: ValueKey("/theme"),
            child: ThemePage(),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        if (_isOnThemePage) {
          _isOnThemePage = false;
          notifyListeners();
          return true;
        }

        if (_gameId != null) {
          _game = null;
          _gameId = null;
          notifyListeners();
          return true;
        }

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) => throw UnimplementedError();

  void goToRegisterPage() {}

  void goToLogin() {
    _isInitialized = true;
    notifyListeners();
  }

  void goToHomePage(UserManager user) {
    _isInitialized = true;
    GetIt.I.registerSingleton<UserManager>(user);
    notifyListeners();
  }

  void goToGamePage(String gameId, [Game? game]) {
    _gameId = gameId;
    _game = game;
    notifyListeners();
  }

  void goToThemePage() {
    _isOnThemePage = true;
    notifyListeners();
  }
}
