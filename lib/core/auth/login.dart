import 'package:bucket_map/core/auth/cubits/login/cubit.dart';
import 'package:bucket_map/core/auth/register.dart';
import 'package:bucket_map/core/auth/repositories/repositories.dart';
import 'package:bucket_map/core/auth/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginPage extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);

  jumpToPage(int page) {
    controller.animateToPage(
      page,
      duration: Duration(milliseconds: 250),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        context.read<AuthenticationRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bucket Map'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(6.0),
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                if (state.loading) {
                  return LinearProgressIndicator();
                }

                return Container();
              },
            ),
          ),
        ),
        body: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            EmailView(
              onNextView: () => jumpToPage(1),
              onRegister: () => Navigator.push(context, RegisterPage.page()),
            ),
            PasswordView(
              onPreviouseView: () => jumpToPage(0),
            ),
          ],
        ),
      ),
    );
  }

  static Page page() => MaterialPage<void>(child: LoginPage());
}

class EmailView extends StatelessWidget {
  const EmailView({this.onNextView, this.onRegister});

  final Function() onNextView;
  final Function() onRegister;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final String labelText = 'E-Mail';
        final isEmailValid = state.emailStatus == FormzStatus.valid;

        return AuthViewContainer(
          title: 'Anmeldung',
          subtitle: 'Melde dich mit deinem Konto an.',
          children: [
            FormInputField(
              onChanged: context.read<LoginCubit>().emailChanged,
              keyboardType: TextInputType.emailAddress,
              labelText: labelText,
              errorText: state.error,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text('Konto erstellen'),
                    onPressed: () {
                      onRegister?.call();
                    },
                  ),
                  ElevatedButton(
                    child: Text('Weiter'),
                    onPressed: !isEmailValid
                        ? null
                        : () async {
                            final result =
                                await context.read<LoginCubit>().verifyEmail();
                            if (!result) return;

                            onNextView?.call();
                          },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class PasswordView extends StatelessWidget {
  const PasswordView({this.onPreviouseView});
  final Function() onPreviouseView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final String labelText = 'Password';

        return AuthViewContainer(
          title: 'Willkommen',
          subtitle: state.email.value,
          children: [
            FormInputField(
              obscureText: true,
              onChanged: context.read<LoginCubit>().passwordChanged,
              keyboardType: TextInputType.emailAddress,
              labelText: labelText,
              errorText: state.error,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(
                      'Zurück',
                    ),
                    onPressed: onPreviouseView?.call,
                  ),
                  ElevatedButton(
                    child: Text('Anmelden'),
                    onPressed: () {
                      context.read<LoginCubit>().logInWithCredentials();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
