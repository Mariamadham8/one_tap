import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyLarge?.color ?? colorScheme.onSurface;
    final hintColor =
        theme.textTheme.bodySmall?.color ?? colorScheme.onSurfaceVariant;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscure : false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(color: textColor, fontSize: 13),
      cursorColor: colorScheme.primary,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: hintColor, fontSize: 13),
        filled: true,
        fillColor: theme.cardColor,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: hintColor,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
