import 'package:bloc_playground/features/firebase_login/cubit/sign_up/sign_up_cubit.dart';
import 'package:bloc_playground/features/firebase_login/view/forms/sign_up_form.dart';
import 'package:bloc_playground/injector.dart';
import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => SignUpCubit(getIt.get<FirebaseAuthRepository>()),
          child: const SignUpForm(),
        ),
      ),
    );
  }
}
