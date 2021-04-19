import 'package:bucket_map/core/auth/cubits/register/cubit.dart';
import 'package:bucket_map/core/auth/register/register_form.dart';
import 'package:bucket_map/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrieren')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider<RegisterCubit>(
          create: (_) => RegisterCubit(
            context.read<AuthenticationRepository>(),
          ),
          child: RegisterForm(),
        ),
      ),
    );
  }
}
