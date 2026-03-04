import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/event.dart';

class EventTypeBadge extends StatelessWidget {
  const EventTypeBadge({super.key, required this.type});

  final EventType type;

  @override
  Widget build(BuildContext context) {
    final (color, bg, label) = switch (type) {
      EventType.cours => (AppColors.primary, AppColors.primaryLight, 'Cours'),
      EventType.reunion => (
          AppColors.secondary,
          const Color(0xFFF3E8FF),
          'Réunion'
        ),
      EventType.deadline => (
          AppColors.danger,
          const Color(0xFFFEE2E2),
          'Deadline'
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderFull,
      ),
      child: Text(
        label,
        style: AppTypography.small.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
