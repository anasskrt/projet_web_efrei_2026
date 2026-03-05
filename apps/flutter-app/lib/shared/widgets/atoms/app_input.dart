library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Champ de saisie Learn@Home.
class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.focusNode,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        enabled: enabled,
        autofocus: autofocus,
        textInputAction: textInputAction,
        focusNode: focusNode,
        maxLines: obscureText ? 1 : maxLines,
        style: AppTypography.body.copyWith(
          color: enabled ? AppColors.textPrimary : AppColors.textDisabled,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          helperText: helperText,
          prefixIcon: prefixIcon != null
              ? Semantics(label: label ?? '', child: Icon(prefixIcon, size: 18))
              : null,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
