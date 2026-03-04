import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/event.dart';
import 'event_type_badge.dart';

class EventDetailWidget extends StatelessWidget {
  const EventDetailWidget({
    super.key,
    required this.event,
    this.linkedTaskTitle,
  });

  final Event event;
  final String? linkedTaskTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(event.title, style: AppTypography.heading),
              ),
              const SizedBox(width: AppSpacing.s2),
              EventTypeBadge(type: event.type),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),
          _InfoRow(
            label: 'Date',
            value: DateFormat('EEEE dd MMMM yyyy à HH:mm', 'fr')
                .format(event.date),
          ),
          if (event.description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s4),
            _InfoRow(label: 'Description', value: event.description),
          ],
          if (linkedTaskTitle != null) ...[
            const SizedBox(height: AppSpacing.s4),
            _InfoRow(label: 'Tâche liée', value: linkedTaskTitle!),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.small.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.s1),
        Text(value, style: AppTypography.body),
      ],
    );
  }
}
