library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';


/// Types de toast disponibles.
enum AppToastType { success, error, warning, info }


/// Affiche un toast conforme à la charte UI Learn@Home.
void showAppToast(
  BuildContext context, {
  required String message,
  AppToastType type = AppToastType.info,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: _AppToastContent(message: message, type: type),
        duration: duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
}


class _AppToastContent extends StatelessWidget {
  const _AppToastContent({required this.message, required this.type});

  final String message;
  final AppToastType type;

  _ToastTokens get _tokens => switch (type) {
    AppToastType.success => const _ToastTokens(
      borderColor: AppColors.success,
      icon: LucideIcons.checkCircle,
      iconColor: AppColors.success,
    ),
    AppToastType.error => const _ToastTokens(
      borderColor: AppColors.danger,
      icon: LucideIcons.xCircle,
      iconColor: AppColors.danger,
    ),
    AppToastType.warning => const _ToastTokens(
      borderColor: AppColors.warning,
      icon: LucideIcons.alertTriangle,
      iconColor: AppColors.warning,
    ),
    AppToastType.info => const _ToastTokens(
      borderColor: AppColors.primary,
      icon: LucideIcons.info,
      iconColor: AppColors.primary,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final tokens = _tokens;

    return Semantics(
      liveRegion: true,
      label: message,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.borderMd,
          border: Border(left: BorderSide(color: tokens.borderColor, width: 4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(tokens.icon, size: 18, color: tokens.iconColor),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                message,
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ToastTokens {
  const _ToastTokens({
    required this.borderColor,
    required this.icon,
    required this.iconColor,
  });

  final Color borderColor;
  final IconData icon;
  final Color iconColor;
}
