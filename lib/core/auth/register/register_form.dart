import 'package:bucket_map/core/auth/cubits/register/cubit.dart';
import 'package:bucket_map/core/auth/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Registrierung fehlgeschlagen!')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmailInput(),
            const SizedBox(height: 8.0),
            _PasswordInput(),
            const SizedBox(height: 8.0),
            _RegisterButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return FormInputField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (email) =>
              context.read<RegisterCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          labelText: 'E-Mail',
          errorText: state.email.invalid ? 'invalid email' : null,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<RegisterCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Passwort',
            helperText: '',
            errorText: state.password.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : FormButton(
                key: const Key('signUpForm_continue_raisedButton'),
                text: 'Registrieren',
                onPressed: state.status.isValidated
                    ? () => context.read<RegisterCubit>().signUpFormSubmitted()
                    : null,
              );
      },
    );
  }
}
