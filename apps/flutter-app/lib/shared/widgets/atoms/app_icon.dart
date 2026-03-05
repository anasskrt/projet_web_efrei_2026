library;

import 'package:flutter/material.dart';

/// Tailles d'icône standardisées.
enum AppIconSize {
  /// 16px — icône inline dans du texte.
  inline(16),

  /// 20px — icône dans un bouton.
  button(20),

  /// 24px — icône de navigation.
  nav(24);

  const AppIconSize(this.dimension);
  final double dimension;
}

/// Icône Lucide accessible avec label et tooltip.
class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.size = AppIconSize.button,
    this.color,
    this.showTooltip = true,
  });

  final IconData icon;
  final String semanticLabel;
  final AppIconSize size;
  final Color? color;
  final bool showTooltip;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Semantics(
      label: semanticLabel,
      child: Icon(icon, size: size.dimension, color: color),
    );

    if (showTooltip) {
      return Tooltip(message: semanticLabel, child: iconWidget);
    }

    return iconWidget;
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.size = AppIconSize.button,
    this.color,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final AppIconSize size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: semanticLabel,
      child: SizedBox(
        width: 44,
        height: 44,
        child: IconButton(
          icon: Icon(icon, size: size.dimension, color: color),
          onPressed: onPressed,
          tooltip: semanticLabel,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
