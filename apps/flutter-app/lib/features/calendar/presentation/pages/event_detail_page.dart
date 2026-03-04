import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../tasks/presentation/providers/task_provider.dart';
import '../../domain/entities/event.dart';
import '../providers/event_provider.dart';
import '../widgets/event_detail_widget.dart';

class EventDetailPage extends ConsumerWidget {
  const EventDetailPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventDetailProvider(eventId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Détail de l\'événement',
          style: AppTypography.subheading,
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (event) {
          if (event == null) {
            return Center(
              child: Text(
                'Événement introuvable',
                style: AppTypography.body,
              ),
            );
          }

          if (event.linkedTaskId != null) {
            final taskAsync =
                ref.watch(taskDetailProvider(event.linkedTaskId!));
            return taskAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _Body(event: event, linkedTaskTitle: null),
              data: (task) => _Body(event: event, linkedTaskTitle: task?.title),
            );
          }

          return _Body(event: event, linkedTaskTitle: null);
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.event, this.linkedTaskTitle});

  final Event event;
  final String? linkedTaskTitle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: EventDetailWidget(event: event, linkedTaskTitle: linkedTaskTitle),
    );
  }
}
