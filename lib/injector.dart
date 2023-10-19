import 'package:get_it/get_it.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

final getIt = GetIt.instance;

void initializeDependencies() {
  // share pref
  getIt.registerSingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  getIt.registerLazySingleton<LocalStorageTodosApi>(
    () => LocalStorageTodosApi(plugin: getIt.get<SharedPreferences>()),
  );

  getIt.registerLazySingleton<TodosRepository>(
    () => TodosRepository(todosApi: getIt.get<LocalStorageTodosApi>()),
  );
}
