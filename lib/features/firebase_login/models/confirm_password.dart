import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { invalid }

class ConfirmPassword
    extends FormzInput<String, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure() : super.pure('');

  const ConfirmPassword.dirty([super.value = '']) : super.dirty();

  static final _confirmPasswordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  ConfirmPasswordValidationError? validator(String value) {
    return _confirmPasswordRegExp.hasMatch(value)
        ? null
        : ConfirmPasswordValidationError.invalid;
  }
}
