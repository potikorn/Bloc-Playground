import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    super.key,
    this.controller,
    this.onChanged,
    this.inputType = TextInputType.text,
    this.label,
    this.helperText,
    this.errorText,
    this.obscureText = false,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextInputType inputType;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: inputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText ?? "",
        errorText: errorText,
      ),
    );
  }
}
