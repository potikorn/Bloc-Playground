import 'package:bloc_playground/features/bloc_authentication/splash/splash.dart';
import 'package:bloc_playground/features/firebase_login/bloc/app/app_bloc.dart';
import 'package:bloc_playground/features/firebase_login/view/home_page.dart';
import 'package:bloc_playground/features/firebase_login/view/login_page.dart';
import 'package:bloc_playground/injector.dart';
import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirebaseLoginApp extends StatelessWidget {
  const FirebaseLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: getIt.get<FirebaseAuthRepository>(),
      child: BlocProvider(
        create: (_) => AppBloc(
          authRepository: getIt.get<FirebaseAuthRepository>(),
        ),
        child: FirebaseLoginAppView(),
      ),
    );
  }
}

class FirebaseLoginAppView extends StatelessWidget {
  FirebaseLoginAppView({super.key});

  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            switch (state.status) {
              case AppStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
                break;
              case AppStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
