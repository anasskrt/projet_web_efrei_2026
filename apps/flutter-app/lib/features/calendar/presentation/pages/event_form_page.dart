import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/atoms/app_button.dart';
import '../../../../shared/widgets/molecules/app_form_field.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/providers/task_provider.dart';
import '../../domain/entities/event.dart';
import '../providers/event_provider.dart';

class EventFormPage extends ConsumerStatefulWidget {
  const EventFormPage({super.key});

  @override
  ConsumerState<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends ConsumerState<EventFormPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _date;
  EventType _type = EventType.cours;
  List<UserModel> _selectedStudents = [];
  Task? _linkedTask;

  String? _titleError;
  String? _dateError;
  String? _studentsError;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      _titleError =
          _titleCtrl.text.trim().isEmpty ? 'Le titre est obligatoire.' : null;
      _dateError = _date == null ? 'La date est obligatoire.' : null;
      _studentsError =
          _selectedStudents.isEmpty ? 'Sélectionnez au moins un élève.' : null;
    });
    return _titleError == null && _dateError == null && _studentsError == null;
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      locale: const Locale('fr'),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_date ?? DateTime.now()),
    );
    if (pickedTime == null || !mounted) return;

    setState(() {
      _date = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _dateError = null;
    });
  }

  Future<void> _submit(String volunteerId) async {
    if (!_validate()) return;

    await ref.read(createEventNotifierProvider.notifier).createEvent(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          type: _type.value,
          date: _date!,
          volunteerId: volunteerId,
          studentIds: _selectedStudents.map((s) => s.uid).toList(),
          linkedTaskId: _linkedTask?.id,
        );

    if (!mounted) return;
    final state = ref.read(createEventNotifierProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${state.error}'),
          backgroundColor: AppColors.danger,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Événement créé avec succès.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserModelProvider);
    final studentsAsync = ref.watch(studentsForVolunteerProvider);
    final tasksAsync = ref.watch(tasksByVolunteerProvider);
    final notifierState = ref.watch(createEventNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
          tooltip: 'Retour',
        ),
        title: Text('Nouvel événement', style: AppTypography.bodyMedium),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SizedBox.shrink(),
        data: (user) {
          if (user == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppFormField(
                  label: 'Titre',
                  hint: 'Ex : Cours de maths',
                  controller: _titleCtrl,
                  prefixIcon: LucideIcons.fileText,
                  errorText: _titleError,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() => _titleError = null),
                ),
                const SizedBox(height: AppSpacing.s4),
                AppFormField(
                  label: 'Description',
                  hint: 'Description optionnelle…',
                  controller: _descCtrl,
                  prefixIcon: LucideIcons.alignLeft,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: AppSpacing.s4),
                _TypeSelector(
                  selected: _type,
                  onChanged: (t) => setState(() => _type = t),
                ),
                const SizedBox(height: AppSpacing.s4),
                _DateTimeField(
                  selectedDate: _date,
                  errorText: _dateError,
                  onTap: _pickDateTime,
                ),
                const SizedBox(height: AppSpacing.s4),
                studentsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.s3),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => Text(
                    'Impossible de charger les élèves.',
                    style:
                        AppTypography.small.copyWith(color: AppColors.danger),
                  ),
                  data: (students) => _StudentsMultiSelect(
                    students: students,
                    selected: _selectedStudents,
                    errorText: _studentsError,
                    onChanged: (list) => setState(() {
                      _selectedStudents = list;
                      _studentsError = null;
                    }),
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                tasksAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (tasks) => _LinkedTaskDropdown(
                    tasks: tasks,
                    selected: _linkedTask,
                    onChanged: (t) => setState(() => _linkedTask = t),
                  ),
                ),
                const SizedBox(height: AppSpacing.s6),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'Créer l\'événement',
                    icon: LucideIcons.plus,
                    isLoading: notifierState.isLoading,
                    onPressed: notifierState.isLoading
                        ? null
                        : () => _submit(user.uid),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.selected, required this.onChanged});

  final EventType selected;
  final ValueChanged<EventType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Type', style: AppTypography.small),
        const SizedBox(height: AppSpacing.s2),
        Row(
          children: EventType.values.map((t) {
            final isSelected = t == selected;
            final (color, label) = switch (t) {
              EventType.cours => (AppColors.primary, 'Cours'),
              EventType.reunion => (AppColors.secondary, 'Réunion'),
              EventType.deadline => (AppColors.danger, 'Deadline'),
            };
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: t != EventType.deadline ? AppSpacing.s2 : 0,
                ),
                child: GestureDetector(
                  onTap: () => onChanged(t),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.s2),
                    decoration: BoxDecoration(
                      color: isSelected ? color : AppColors.surface,
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: AppTypography.small.copyWith(
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.selectedDate,
    required this.onTap,
    this.errorText,
  });

  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final label = selectedDate == null
        ? 'Date et heure'
        : DateFormat('EEEE d MMMM yyyy · HH:mm', 'fr').format(selectedDate!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s3,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: errorText != null ? AppColors.danger : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.calendar,
                    size: 18, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.body.copyWith(
                      color: selectedDate == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(LucideIcons.chevronDown,
                    size: 16, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.s1),
          Text(
            errorText!,
            style: AppTypography.small.copyWith(color: AppColors.danger),
          ),
        ],
      ],
    );
  }
}

class _StudentsMultiSelect extends StatelessWidget {
  const _StudentsMultiSelect({
    required this.students,
    required this.selected,
    required this.onChanged,
    this.errorText,
  });

  final List<UserModel> students;
  final List<UserModel> selected;
  final ValueChanged<List<UserModel>> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Élèves invités', style: AppTypography.small),
        const SizedBox(height: AppSpacing.s2),
        if (students.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.s3),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.userX,
                    size: 18, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.s3),
                Text(
                  'Aucun élève assigné.',
                  style: AppTypography.body
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: errorText != null ? AppColors.danger : AppColors.border,
              ),
            ),
            child: Column(
              children: students.map((s) {
                final isChecked = selected.any((sel) => sel.uid == s.uid);
                return CheckboxListTile(
                  value: isChecked,
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primary,
                  title: Text(
                    '${s.firstName} ${s.lastName}',
                    style: AppTypography.body,
                  ),
                  onChanged: (checked) {
                    final updated = List<UserModel>.from(selected);
                    if (checked == true) {
                      updated.add(s);
                    } else {
                      updated.removeWhere((sel) => sel.uid == s.uid);
                    }
                    onChanged(updated);
                  },
                );
              }).toList(),
            ),
          ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.s1),
          Text(
            errorText!,
            style: AppTypography.small.copyWith(color: AppColors.danger),
          ),
        ],
      ],
    );
  }
}

class _LinkedTaskDropdown extends StatelessWidget {
  const _LinkedTaskDropdown({
    required this.tasks,
    required this.selected,
    required this.onChanged,
  });

  final List<Task> tasks;
  final Task? selected;
  final ValueChanged<Task?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tâche liée (optionnel)', style: AppTypography.small),
        const SizedBox(height: AppSpacing.s2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Task?>(
              value: selected,
              isExpanded: true,
              hint: Text(
                'Aucune tâche liée',
                style:
                    AppTypography.body.copyWith(color: AppColors.textSecondary),
              ),
              items: [
                DropdownMenuItem<Task?>(
                  value: null,
                  child: Text(
                    'Aucune',
                    style: AppTypography.body
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
                ...tasks.map(
                  (t) => DropdownMenuItem<Task?>(
                    value: t,
                    child: Text(t.title, style: AppTypography.body),
                  ),
                ),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
