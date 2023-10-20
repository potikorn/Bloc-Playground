import 'package:bloc/bloc.dart';
import 'package:bloc_playground/features/firebase_login/models/inputs.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_repository/firebase_auth_repository.dart';
import 'package:formz/formz.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._firebaseAuthRepository) : super(const SignUpState());

  final FirebaseAuthRepository _firebaseAuthRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          email,
          state.password,
          state.confirmPassword,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([
          state.email,
          password,
          state.confirmPassword,
        ]),
      ),
    );
  }

  void confirmPasswordChanged(String value) {
    final confirmPassword = ConfirmPassword.dirty(value);
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isValid: Formz.validate([
          state.email,
          state.password,
          confirmPassword,
        ]),
      ),
    );
  }

  Future<void> signUpFormSubmitted() async {
    if (!state.isValid) {
      return;
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _firebaseAuthRepository.signUp(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
      ));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
