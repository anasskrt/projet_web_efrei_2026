library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';


/// Variantes visuelles de la carte.
enum AppCardVariant { elevated, flat }


/// Carte de contenu Learn@Home.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final AppCardVariant variant;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final isElevated = variant == AppCardVariant.elevated;

    final container = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.border),
        boxShadow: isElevated ? AppShadows.sm : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.borderMd,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.borderMd,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
            child: child,
          ),
        ),
      ),
    );

    if (semanticLabel != null && onTap != null) {
      return Semantics(button: true, label: semanticLabel, child: container);
    }

    return container;
  }
}
