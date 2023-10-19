import 'package:bloc_playground/features/todo/view/home_page.dart';
import 'package:bloc_playground/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: getIt.get<TodosRepository>(),
      child: const HomePage(),
    );
  }
}
