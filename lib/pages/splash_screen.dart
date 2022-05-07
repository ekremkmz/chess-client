import '../data/rest/dio_manager.dart';
import '../data/local/models/user.dart';
import '../errors/failure.dart';
import '../helper/init_app_dependencies.dart';
import '../logic/router/my_router_delagate.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // init app but wait at least 3 seconds
    Future.wait([
      initApp(context),
      Future.delayed(const Duration(seconds: 3)),
    ]).then((value) {
      final res = value[0] as Either<Failure, User>;
      res.fold(
        (left) => context.read<MyRouterDelegate>().goToLogin(),
        context.read<MyRouterDelegate>().goToHomePage,
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

  Future<Either<Failure, User>> initApp(BuildContext context) async {
    await initAppDependencies();

    return await DioManager.instance.getProfile();
  }
}
