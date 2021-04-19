import 'package:bucket_map/core/auth/cubits/login/cubit.dart';
import 'package:bucket_map/core/auth/login/login_form.dart';
import 'package:bucket_map/core/auth/register/register.dart';
import 'package:bucket_map/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  static Page page() => MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anmelden'),
        actions: [
          TextButton(
            key: const Key('loginForm_createAccount_flatButton'),
            child: const Text('Registrieren'),
            onPressed: () => Navigator.of(context).push<void>(
              RegisterPage.route(),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
          child: LoginForm(),
        ),
      ),
    );
  }
}
