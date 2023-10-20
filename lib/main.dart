import 'dart:async';
import 'dart:developer';

import 'package:bloc_playground/app.dart';
import 'package:bloc_playground/firebase_options.dart';
import 'package:bloc_playground/injector.dart';
import 'package:bloc_playground/simple_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (details) {
        log(details.exceptionAsString(), stackTrace: details.stack);
      };
      Bloc.observer = SimpleBlocObserver();
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getTemporaryDirectory(),
      );
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      initializeDependencies();
      return runApp(const BlocPlaygroundApp());
    },
    (error, stack) => log(error.toString(), stackTrace: stack),
  );
}
