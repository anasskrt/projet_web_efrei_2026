library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../atoms/app_icon.dart';
import '../atoms/app_status_badge.dart';

/// Élément de liste d'une tâche.
class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.title,
    required this.status,
    this.subtitle,
    this.isCompleted = false,
    this.onTap,
    this.onActionTap,
    this.actionIcon = LucideIcons.trash2,
    this.actionLabel = 'Action sur la tâche',
  });

  final String title;
  final TaskStatus status;
  final String? subtitle;
  final bool isCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;
  final IconData actionIcon;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tâche : $title, statut : ${status.label}',
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s3,
            horizontal: AppSpacing.s4,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Icône de statut ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 2, right: AppSpacing.s3),
                child: Icon(
                  isCompleted ? LucideIcons.checkCircle2 : LucideIcons.circle,
                  size: 18,
                  color: isCompleted
                      ? AppColors.success
                      : AppColors.textSecondary,
                ),
              ),

              // ─── Contenu principal ────────────────────────────────────
              Expanded(
                child: Opacity(
                  opacity: isCompleted ? 0.6 : 1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.bodyMedium.copyWith(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.s1),
                        Text(subtitle!, style: AppTypography.small),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.s3),

              // ─── Badge + Action ───────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppStatusBadge(status: status),
                  if (onActionTap != null) ...[
                    const SizedBox(height: AppSpacing.s1),
                    AppIconButton(
                      icon: actionIcon,
                      semanticLabel: actionLabel,
                      onPressed: onActionTap,
                      size: AppIconSize.inline,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
