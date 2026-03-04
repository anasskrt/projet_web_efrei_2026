import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/event.dart';
import 'event_type_badge.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, this.onTap});

  final Event event;
  final VoidCallback? onTap;

  Color get _borderColor => switch (event.type) {
        EventType.cours => AppColors.primary,
        EventType.reunion => AppColors.secondary,
        EventType.deadline => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
        padding: const EdgeInsets.all(AppSpacing.s3),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(left: BorderSide(color: _borderColor, width: 3)),
          borderRadius: AppRadius.borderMd,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.s1),
                  Text(
                    DateFormat('dd MMM yyyy · HH:mm', 'fr').format(event.date),
                    style: AppTypography.small
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s2),
            EventTypeBadge(type: event.type),
          ],
        ),
      ),
    );
  }
}
