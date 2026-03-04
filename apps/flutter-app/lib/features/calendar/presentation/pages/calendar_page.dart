import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../domain/entities/event.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<Event> _eventsForDay(List<Event> all, DateTime day) {
    return all.where((e) => isSameDay(e.date, day)).toList();
  }

  Color _colorForType(EventType type) => switch (type) {
        EventType.cours => AppColors.primary,
        EventType.reunion => AppColors.secondary,
        EventType.deadline => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsForCurrentUserProvider);
    final userAsync = ref.watch(currentUserModelProvider);
    final isVolunteer = userAsync.valueOrNull?.role == UserRole.volunteer;

    return eventsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (events) {
        final selectedEvents = _eventsForDay(events, _selectedDay);

        return Stack(
          children: [
            Column(
              children: [
                TableCalendar<Event>(
                  locale: 'fr_FR',
                  firstDay: DateTime(2020),
                  lastDay: DateTime(2030),
                  focusedDay: _focusedDay,
                  calendarFormat: _format,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  eventLoader: (day) => _eventsForDay(events, day),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      _selectedDay = selected;
                      _focusedDay = focused;
                    });
                  },
                  onFormatChanged: (format) => setState(() => _format = format),
                  onPageChanged: (focused) =>
                      setState(() => _focusedDay = focused),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: AppTypography.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: AppTypography.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                  ),
                  calendarBuilders: CalendarBuilders<Event>(
                    markerBuilder: (context, day, dayEvents) {
                      if (dayEvents.isEmpty) return null;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dayEvents
                            .take(3)
                            .map(
                              (e) => Container(
                                width: 6,
                                height: 6,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: _colorForType(e.type),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: selectedEvents.isEmpty
                      ? Center(
                          child: Text(
                            'Aucun événement ce jour',
                            style: AppTypography.body
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            left: AppSpacing.s4,
                            right: AppSpacing.s4,
                            top: AppSpacing.s4,
                            bottom: isVolunteer ? 80 : AppSpacing.s4,
                          ),
                          itemCount: selectedEvents.length,
                          itemBuilder: (_, i) => EventCard(
                            event: selectedEvents[i],
                            onTap: () => context
                                .push('/calendar/${selectedEvents[i].id}'),
                          ),
                        ),
                ),
              ],
            ),
            if (isVolunteer)
              Positioned(
                right: AppSpacing.pagePadding,
                bottom: AppSpacing.pagePadding,
                child: FloatingActionButton.extended(
                  onPressed: () => context.push('/calendar/new'),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  icon: const Icon(LucideIcons.plus),
                  label: Text(
                    'Nouvel événement',
                    style: AppTypography.small.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
