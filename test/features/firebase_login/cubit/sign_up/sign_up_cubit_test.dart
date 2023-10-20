import 'package:bloc_playground/features/firebase_login/cubit/sign_up/sign_up_cubit.dart';
import 'package:bloc_playground/features/firebase_login/models/inputs.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthRepository extends Mock
    implements FirebaseAuthRepository {}

void main() {
  group('SignUpCubit', () {
    late FirebaseAuthRepository firebaseAuthRepository;
    late SignUpCubit signUpCubit;

    setUp(() {
      firebaseAuthRepository = MockFirebaseAuthRepository();
      signUpCubit = SignUpCubit(firebaseAuthRepository);
    });

    test('initial state is correct', () {
      final signUpCubit = SignUpCubit(firebaseAuthRepository);
      expect(signUpCubit.state, const SignUpState());
    });

    group('email input changed', () {
      blocTest<SignUpCubit, SignUpState>(
        'with valid value',
        build: () => signUpCubit,
        act: (bloc) => bloc.emailChanged("a@a.com"),
        verify: (bloc) {
          expect(bloc.state.email.value, "a@a.com");
          expect(bloc.state.email.isValid, equals(true));
        },
      );

      blocTest<SignUpCubit, SignUpState>(
        'with invalid value',
        build: () => signUpCubit,
        act: (bloc) => bloc.emailChanged("usernameOrMail"),
        verify: (bloc) {
          expect(bloc.state.email.value, "usernameOrMail");
          expect(bloc.state.email.isValid, equals(false));
        },
      );
    });

    group('password input changed', () {
      blocTest<SignUpCubit, SignUpState>(
        'with valid value',
        build: () => signUpCubit,
        act: (bloc) => bloc.passwordChanged("Abcd1234"),
        verify: (bloc) {
          expect(bloc.state.password.value, "Abcd1234");
          expect(bloc.state.password.isValid, equals(true));
          expect(bloc.state.password.error, equals(isNull));
        },
      );

      blocTest<SignUpCubit, SignUpState>(
        'with invalid value only digit',
        build: () => signUpCubit,
        act: (bloc) => bloc.passwordChanged("12345678"),
        verify: (bloc) {
          expect(bloc.state.password.value, "12345678");
          expect(bloc.state.password.isValid, equals(false));
          expect(
            bloc.state.password.error?.errorType,
            PasswordValidationError.invalid,
          );
        },
      );

      blocTest<SignUpCubit, SignUpState>(
        'with invalid value at least 8 characters',
        build: () => signUpCubit,
        act: (bloc) => bloc.passwordChanged("123456"),
        verify: (bloc) {
          expect(bloc.state.password.value, "123456");
          expect(bloc.state.password.isValid, equals(false));
          expect(
            bloc.state.password.error?.errorType,
            PasswordValidationError.tooShort,
          );
        },
      );

      blocTest<SignUpCubit, SignUpState>(
        'with invalid value over 32 characters',
        build: () => signUpCubit,
        act: (bloc) =>
            bloc.passwordChanged('1234567890132412345besac45092ldcert340'),
        verify: (bloc) {
          expect(bloc.state.password.value,
              "1234567890132412345besac45092ldcert340");
          expect(bloc.state.password.isValid, equals(false));
          expect(
            bloc.state.password.error?.errorType,
            PasswordValidationError.tooLong,
          );
        },
      );
    });
  });
}
