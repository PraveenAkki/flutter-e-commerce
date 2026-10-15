import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class PasswordTextField extends StatefulWidget {
  final String? errorText;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmitted;

  const PasswordTextField({
    super.key,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
    this.onSubmitted,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _isHidden,
      enabled: widget.enabled,
      textInputAction: TextInputAction.done,
      onChanged: widget.onChanged,
      onSubmitted: (_) => widget.onSubmitted?.call(),
      decoration: InputDecoration(
        labelText: AppStrings.passwordLabel,
        errorText: widget.errorText,
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(_isHidden ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _isHidden = !_isHidden),
        ),
      ),
    );
  }
}