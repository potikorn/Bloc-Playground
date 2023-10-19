import 'package:bloc_playground/features/weather/cubit/weather_cubit.dart';
import 'package:bloc_playground/features/weather/theme/cubit/theme_cubit.dart';
import 'package:bloc_playground/features/weather/view/search_page.dart';
import 'package:bloc_playground/features/weather/view/storage_page.dart';
import 'package:bloc_playground/features/weather/view/weather_page.dart';
import 'package:bloc_playground/features/weather/view/widgets/weather_empty.dart';
import 'package:bloc_playground/features/weather/view/widgets/weather_error.dart';
import 'package:bloc_playground/features/weather/view/widgets/weather_loading.dart';
import 'package:bloc_playground/features/weather/view/widgets/weather_populated.dart';
import 'package:bloc_playground/features/weather/weather.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart' hide Weather;

import '../../../helpers/hydrated_bloc.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockThemeCubit extends MockCubit<Color> implements ThemeCubit {}

class MockWeatherCubit extends MockCubit<WeatherState>
    implements WeatherCubit {}

void main() {
  initHydratedStorage();

  group('WeatherPage', () {
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherRepository = MockWeatherRepository();
    });

    testWidgets('renders WeatherView', (widgetTester) async {
      await widgetTester.pumpWidget(
        RepositoryProvider.value(
          value: weatherRepository,
          child: const MaterialApp(home: WeatherPage()),
        ),
      );
      expect(find.byType(WeatherView), findsOneWidget);
    });
  });

  group('WeatherView', () {
    final weather = Weather(
      temperature: Temperature(value: 4.2),
      condition: WeatherCondition.cloudy,
      lastUpdated: DateTime(2020),
      location: 'London',
    );
    late ThemeCubit themeCubit;
    late WeatherCubit weatherCubit;

    setUp(() {
      themeCubit = MockThemeCubit();
      weatherCubit = MockWeatherCubit();
    });

    testWidgets(
      'renders WeatherEmpty for WeatherStatus.initial',
      (widgetTester) async {
        when(() => weatherCubit.state).thenReturn(WeatherState());
        await widgetTester.pumpWidget(
          BlocProvider.value(
            value: weatherCubit,
            child: const MaterialApp(home: WeatherView()),
          ),
        );
        expect(find.byType(WeatherEmpty), findsOneWidget);
      },
    );

    testWidgets(
      'renders WeatherLoading for WeatherStatus.loading',
      (widgetTester) async {
        when(() => weatherCubit.state).thenReturn(
          WeatherState(status: WeatherStatus.loading),
        );
        await widgetTester.pumpWidget(
          BlocProvider.value(
            value: weatherCubit,
            child: const MaterialApp(home: WeatherView()),
          ),
        );
        expect(find.byType(WeatherLoading), findsOneWidget);
      },
    );

    testWidgets(
      'renders WeatherPopulated for WeatherStatus.success',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(
          WeatherState(
            status: WeatherStatus.success,
            weather: weather,
          ),
        );
        await tester.pumpWidget(
          BlocProvider.value(
            value: weatherCubit,
            child: const MaterialApp(home: WeatherView()),
          ),
        );
        expect(find.byType(WeatherPopulated), findsOneWidget);
      },
    );

    testWidgets(
      'renders WeatherError for WeatherStatus.failure',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(
          WeatherState(
            status: WeatherStatus.failure,
          ),
        );
        await tester.pumpWidget(
          BlocProvider.value(
            value: weatherCubit,
            child: const MaterialApp(home: WeatherView()),
          ),
        );
        expect(find.byType(WeatherError), findsOneWidget);
      },
    );

    testWidgets(
      'state is cached',
      (widgetTester) async {
        when(() => storage.read('$WeatherCubit')).thenReturn(
          WeatherState(
            status: WeatherStatus.success,
            weather: weather,
            temperatureUnits: TemperatureUnits.fahrenheit,
          ).toJson(),
        );
        await widgetTester.pumpWidget(
          BlocProvider.value(
            value: WeatherCubit(MockWeatherRepository()),
            child: const MaterialApp(home: WeatherView()),
          ),
        );
        expect(find.byType(WeatherPopulated), findsOneWidget);
      },
    );

    testWidgets(
      'navigates to SettingPage when settings icon is tapped',
      (widgetTester) async {
        when(() => weatherCubit.state).thenReturn(WeatherState());
        await widgetTester.pumpWidget(
          BlocProvider.value(
            value: weatherCubit,
            child: const MaterialApp(home: WeatherView()),
          ),
        );
        await widgetTester.tap(find.byType(IconButton));
        await widgetTester.pumpAndSettle();
        expect(find.byType(SettingsPage), findsOneWidget);
      },
    );

    testWidgets(
      'navigates to SearchPage when search button is tapped',
      (tester) async {
        when(() => weatherCubit.state).thenReturn(WeatherState());
        await tester.pumpWidget(
          BlocProvider.value(
            value: weatherCubit,
            child: const MaterialApp(home: WeatherView()),
          ),
        );
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        expect(find.byType(SearchPage), findsOneWidget);
      },
    );

    testWidgets(
      'calls updateTheme when weather changes',
      (widgetTester) async {
        whenListen(
          weatherCubit,
          Stream<WeatherState>.fromIterable([
            WeatherState(),
            WeatherState(status: WeatherStatus.success, weather: weather)
          ]),
        );
        when(() => weatherCubit.state).thenReturn(WeatherState(
          status: WeatherStatus.success,
          weather: weather,
        ));
        await widgetTester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: themeCubit),
              BlocProvider.value(value: weatherCubit),
            ],
            child: const MaterialApp(home: WeatherView()),
          ),
        );
        verify(() => themeCubit.updateTheme(weather)).called(1);
      },
    );

    testWidgets(
      'triggers refreshWeather on pull to refresh',
      (widgetTester) async {
        when(() => weatherCubit.state).thenReturn(
          WeatherState(
            status: WeatherStatus.success,
            weather: weather,
          ),
        );
        when(() => weatherCubit.refreshWeather()).thenAnswer((_) async {});
        await widgetTester.pumpWidget(
          BlocProvider.value(
            value: weatherCubit,
            child: const MaterialApp(home: WeatherView()),
          ),
        );
        await widgetTester.fling(
          find.text('London'),
          const Offset(0, 500),
          1000,
        );
        await widgetTester.pumpAndSettle();
        verify(() => weatherCubit.refreshWeather()).called(1);
      },
    );

    testWidgets(
      'triggers fetch on search pop',
      (widgetTester) async {
        when(() => weatherCubit.state).thenReturn(WeatherState());
        when(() => weatherCubit.fetchWeather(any())).thenAnswer(
          (_) async => {},
        );
        await widgetTester.pumpWidget(
          BlocProvider.value(
            value: weatherCubit,
            child: const MaterialApp(home: WeatherView()),
          ),
        );
        await widgetTester.tap(find.byType(FloatingActionButton));
        await widgetTester.pumpAndSettle();
        await widgetTester.enterText(find.byType(TextField), 'Chicago');
        await widgetTester.tap(
          find.byKey(const Key('searchPage_search_iconButton')),
        );
        await widgetTester.pumpAndSettle();
        verify(() => weatherCubit.fetchWeather('Chicago')).called(1);
      },
    );
  });
}
