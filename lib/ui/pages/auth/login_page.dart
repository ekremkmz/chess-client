import 'package:get_it/get_it.dart';

import '../../../data/rest/dio_manager.dart';
import '../../../logic/router/my_router_delagate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _visibilityNotifier = ValueNotifier<Visibility>(Visibility.nonVisible);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTitle(),
          const SizedBox(height: 20),
          _buildUsernameField(context),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 20),
          _buildLoginButton(context),
          const SizedBox(height: 10),
          _buildRegisterButton(context),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext ctx) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
          ),
        ),
      ),
      onPressed: ctx.read<MyRouterDelegate>().goToRegisterPage,
      child: const FractionallySizedBox(
        alignment: Alignment.center,
        widthFactor: 0.5,
        child: Text(
          "Register",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext ctx) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero),
          ),
        ),
      ),
      onPressed: () async {
        final username = _usernameController.text;
        final password = _passwordController.text;
        final router = ctx.read<MyRouterDelegate>();

        final result = await GetIt.I<DioManager>().login(username, password);

        result.fold((left) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(left.message),
            ),
          );
        }, router.goToHomePage);
      },
      child: const FractionallySizedBox(
        alignment: Alignment.center,
        widthFactor: 0.5,
        child: Text(
          "Login",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.zero),
    );

    return ValueListenableBuilder<Visibility>(
      valueListenable: _visibilityNotifier,
      builder: (context, state, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.fromSwatch().copyWith(primary: Colors.black),
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: state == Visibility.nonVisible,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () {
                  _visibilityNotifier.value =
                      _visibilityNotifier.value == Visibility.nonVisible
                          ? Visibility.visible
                          : Visibility.nonVisible;
                },
                child: state == Visibility.nonVisible
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
              border: border,
              focusedBorder: border,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField(BuildContext ctx) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.zero),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.black),
        ),
        child: TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(Icons.account_circle),
            border: border,
            focusedBorder: border,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "CHESS",
      style: TextStyle(
        fontSize: 40,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

enum Visibility {
  visible,
  nonVisible,
}
