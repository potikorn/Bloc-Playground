import 'package:bloc_playground/features/firebase_login/cubit/login/login_cubit.dart';
import 'package:bloc_playground/features/firebase_login/view/forms/login_form.dart';
import 'package:bloc_playground/injector.dart';
import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => LoginCubit(getIt.get<FirebaseAuthRepository>()),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
