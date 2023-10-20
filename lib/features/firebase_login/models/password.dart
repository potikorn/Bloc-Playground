import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

enum PasswordValidationError { invalid, tooShort, tooLong, unknown }

class PasswordError extends Equatable {
  final PasswordValidationError errorType;
  final String message;

  const PasswordError({
    this.errorType = PasswordValidationError.unknown,
    this.message = "",
  });

  factory PasswordError.invalid() => const PasswordError(
        errorType: PasswordValidationError.invalid,
        message: "invalid",
      );

  factory PasswordError.tooShort() => const PasswordError(
        errorType: PasswordValidationError.tooShort,
        message: "tooShort",
      );

  factory PasswordError.tooLong() => const PasswordError(
        errorType: PasswordValidationError.tooLong,
        message: "too long over 32 characters",
      );

  @override
  List<Object?> get props => [errorType, message];
}

class Password extends FormzInput<String, PasswordError> {
  const Password.pure() : super.pure('');

  const Password.dirty([super.value = '']) : super.dirty();

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordError? validator(String value) {
    if (value.isEmpty) {
      return null;
    }
    if (value.length < 8) {
      return PasswordError.tooShort();
    } else if (value.length > 32) {
      return PasswordError.tooLong();
    } else if (!_passwordRegExp.hasMatch(value)) {
      return PasswordError.invalid();
    }
    return null;
  }
}
