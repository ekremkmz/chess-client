import '../../data/local/models/user.dart';
import '../cubit/game_board_logic/game_board_logic_cubit.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/game_page/game_page.dart';
import '../../pages/home_page/home_page.dart';
import '../../pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();

  final _heroController = HeroController();

  User? _user;

  bool _isInitialized = false;

  String? _gameId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyRouterDelegate>.value(
          value: this,
        ),
        Provider.value(
          value: _user,
        )
      ],
      child: Navigator(
        key: _navigatorKey,
        observers: [_heroController],
        pages: [
          if (!_isInitialized)
            const MaterialPage(
              child: SplashScreen(),
            )
          else if (_user == null)
            MaterialPage(
              child: LoginPage(),
            )
          else
            const MaterialPage(
              child: HomePage(),
            ),
          if (_gameId != null)
            MaterialPage(
              child: BlocProvider(
                create: (context) => GameBoardLogicCubit(_gameId!),
                child: const GamePage(),
              ),
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
  Future<void> setNewRoutePath(configuration) => throw UnimplementedError();

  void goToRegisterPage() {}

  void goToLogin() {
    _isInitialized = true;
    notifyListeners();
  }

  void goToHomePage(User user) {
    _user = user;
    _isInitialized = true;
    notifyListeners();
  }

  void goToGamePage(String gameId) {
    _gameId = gameId;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      super.notifyListeners();
    });
  }
}
