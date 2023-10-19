import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

late Storage storage;

void initHydratedStorage() async {
  storage = MockStorage();
  when(
    () => storage.write(
      any(),
      any<dynamic>(),
    ),
  ).thenAnswer((_) async => {});
  HydratedBloc.storage = storage;
}
