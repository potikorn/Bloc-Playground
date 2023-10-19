import 'package:bloc_playground/features/todo/edit_todo/view/edit_todo_page.dart';
import 'package:bloc_playground/features/todo/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:bloc_playground/features/todo/todos_overview/widgets/todos_overview_option.dart';
import 'package:bloc_playground/features/todo/todos_overview/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const TodosOverviewSubscriptionRequested()),
      child: TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo overview appbar title'),
        actions: [
          TodosOverviewOptionButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) {
              return previous.status != current.status;
            },
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("error todos not shown properly"),
                    ),
                  );
              }
            },
          ),
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) {
              return previous.lastDeletedTodo != current.lastDeletedTodo &&
                  current.lastDeletedTodo != null;
            },
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text("deleted ${deletedTodo.title}"),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<TodosOverviewBloc>()
                            .add(const TodosOverviewUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          )
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (BuildContext context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else if (state.status != TodosOverviewStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    "No records",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }
            final todos = state.filteredTodos.toList();
            return CupertinoScrollbar(
              child: ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return TodoListTile(
                    todo: todo,
                    onToggleCompleted: (isCompleted) {
                      context.read<TodosOverviewBloc>().add(
                            TodosOverviewTodoCompletionToggled(
                              todo: todo,
                              isCompleted: isCompleted,
                            ),
                          );
                    },
                    onDismissed: (_) {
                      context
                          .read<TodosOverviewBloc>()
                          .add(TodosOverviewTodoDeleted(todo));
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        EditTodoPage.route(initialTodo: todo),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
