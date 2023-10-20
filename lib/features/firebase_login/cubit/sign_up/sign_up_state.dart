part of 'sign_up_cubit.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  SignUpState copyWith({
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    bool? isValid,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        isValid,
        status,
        errorMessage,
      ];
}
