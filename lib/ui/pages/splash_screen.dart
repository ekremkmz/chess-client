import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../data/rest/dio_manager.dart';
import '../../data/runtime/user_manager.dart';
import '../../errors/failure.dart';
import '../../helper/init_app_dependencies.dart';
import '../../logic/router/my_router_delagate.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // init app but wait at least 3 seconds
    Future.wait([
      initApp(),
      Future.delayed(const Duration(seconds: 3)),
    ]).then((value) {
      final res = value[0] as Either<Failure, UserManager>;
      res.fold(
        (left) => context.read<MyRouterDelegate>().goToLogin(),
        (user) {
          context.read<MyRouterDelegate>().goToHomePage(user);
        },
      );
    });
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }

  Future<Either<Failure, UserManager>> initApp() async {
    await initAppDependencies();

    return await GetIt.I<DioManager>().getProfile();
  }
}
