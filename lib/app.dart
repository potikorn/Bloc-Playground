import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_playground/features/bloc_authentication/bloc_authentication_app.dart';
import 'package:bloc_playground/features/firebase_login/firebase_login_app.dart';
import 'package:bloc_playground/features/timer/timer.dart';
import 'package:bloc_playground/features/infinite_list/view/posts_page.dart';
import 'package:bloc_playground/features/todo/todo_app.dart';
import 'package:bloc_playground/features/weather/weather_app.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

import 'features/counter/view/counter_page.dart';

class BlocPlaygroundApp extends StatelessWidget {
  const BlocPlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Counter'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const CounterPage();
                }));
              },
            ),
            ListTile(
              title: const Text('Timer'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const TimerPage();
                }));
              },
            ),
            ListTile(
              title: const Text('Infinite List'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const PostsPage();
                }));
              },
            ),
            ListTile(
              title: const Text('Login with Bloc'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BlocAuthenticationApp(
                    authenticationRepository: AuthenticationRepository(),
                    userRepository: UserRepository(),
                  );
                }));
              },
            ),
            ListTile(
              title: const Text('Weather'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const WeatherApp();
                }));
              },
            ),
            ListTile(
              title: const Text('Todos'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const TodoApp();
                }));
              },
            ),
            ListTile(
              title: const Text('Firebase Login'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const FirebaseLoginApp();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
