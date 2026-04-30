import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/networking/api_exception.dart';
import '../../../shared/models/activity_type.dart';
import '../../../shared/utils/activity_type_labels.dart';
import '../../../shared/widgets/loading_view.dart';
import '../data/plan_models.dart';
import '../data/plans_repository.dart';

class PlanEditorScreen extends StatefulWidget {
  const PlanEditorScreen({
    required this.repository,
    this.planId,
    super.key,
  });

  final PlansRepository repository;
  final int? planId;

  bool get isEditMode => planId != null;

  @override
  State<PlanEditorScreen> createState() => _PlanEditorScreenState();
}

class _PlanEditorScreenState extends State<PlanEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<_EditableTrainingDay> _days = [];

  DateTime? _startDate;
  DateTime? _stravaEvaluationStartDate;
  ActivityType _planType = ActivityType.run;
  bool _loading = false;
  bool _saving = false;
  String _errorMessage = '';
  int _nextLocalDayId = 1;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      _loadPlan();
    } else {
      _addDay();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (final day in _days) {
      day.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Center(child: LoadingView(label: l10n.plansEditorLoading));
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _EditorHeader(isEditMode: widget.isEditMode),
          if (_errorMessage.isNotEmpty) ...[
            const SizedBox(height: 16),
            _EditorErrorBanner(message: _errorMessage),
          ],
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.plansEditorSectionPlan.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.accentDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: l10n.plansEditorName),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: l10n.plansEditorDescription,
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _DatePickerField(
                    label: l10n.plansEditorStartDate,
                    value: _startDate,
                    required: true,
                    onSelected: (date) {
                      setState(() {
                        _startDate = date;
                        _stravaEvaluationStartDate ??= date;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  _DatePickerField(
                    label: l10n.plansEditorStravaStartDate,
                    value: _stravaEvaluationStartDate,
                    onSelected: (date) {
                      setState(() {
                        _stravaEvaluationStartDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<ActivityType>(
                    initialValue: _planType,
                    decoration: InputDecoration(labelText: l10n.plansEditorPlanType),
                    items: ActivityType.values
                        .map(
                          (type) => DropdownMenuItem<ActivityType>(
                            value: type,
                            child: Text(activityTypeLabel(context, type)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _planType = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.plansEditorSectionDays.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.accentDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.plansEditorDaysHint,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _addDay,
                        icon: const Icon(Icons.add_rounded),
                        label: Text(l10n.plansEditorAddDay),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_days.isEmpty)
                    Text(
                      l10n.plansEditorAtLeastOneDay,
                      style: const TextStyle(color: AppColors.danger),
                    )
                  else
                    for (var index = 0; index < _days.length; index++) ...[
                      _TrainingDayEditorCard(
                        key: ValueKey(_days[index].localId),
                        index: index,
                        day: _days[index],
                        onRemove: _days.length == 1
                            ? null
                            : () => _removeDay(index),
                        onMoveUp: index == 0 ? null : () => _moveDay(index, -1),
                        onMoveDown: index == _days.length - 1
                            ? null
                            : () => _moveDay(index, 1),
                        onDateSelected: (date) {
                          setState(() {
                            _days[index].scheduledDate = date;
                          });
                        },
                        onActivityChanged: (type) {
                          setState(() {
                            _days[index].activityType = type;
                          });
                        },
                      ),
                      if (index < _days.length - 1) const SizedBox(height: 12),
                    ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : () => context.pop(),
                  child: Text(l10n.plansCancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.isEditMode
                              ? l10n.plansSaveChanges
                              : l10n.plansSavePlan,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _loadPlan() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      final plan = await widget.repository.getPlan(widget.planId!);
      _nameController.text = plan.name;
      _descriptionController.text = plan.description ?? '';
      _startDate = plan.startDate;
      _stravaEvaluationStartDate = plan.stravaEvaluationStartDate ?? plan.startDate;
      _planType = plan.planType;
      _replaceDays(
        plan.trainingDays.isEmpty
            ? [_EditableTrainingDay.empty(_nextLocalDayId++)]
            : plan.trainingDays.map(_EditableTrainingDay.fromPlanDay).toList(),
      );
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'Nie udalo sie pobrac planu.';
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _replaceDays(List<_EditableTrainingDay> nextDays) {
    for (final day in _days) {
      day.dispose();
    }
    _days
      ..clear()
      ..addAll(nextDays);
    final maxId = _days.fold<int>(0, (max, day) => day.localId > max ? day.localId : max);
    _nextLocalDayId = maxId + 1;
  }

  void _addDay() {
    setState(() {
      _days.add(_EditableTrainingDay.empty(_nextLocalDayId++));
    });
  }

  void _removeDay(int index) {
    setState(() {
      final day = _days.removeAt(index);
      day.dispose();
      if (_days.isEmpty) {
        _days.add(_EditableTrainingDay.empty(_nextLocalDayId++));
      }
    });
  }

  void _moveDay(int index, int direction) {
    final targetIndex = index + direction;
    if (targetIndex < 0 || targetIndex >= _days.length) {
      return;
    }

    setState(() {
      final day = _days.removeAt(index);
      _days.insert(targetIndex, day);
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();

    final formValid = _formKey.currentState?.validate() ?? false;
    final datesValid = _startDate != null && _days.every((day) => day.scheduledDate != null);
    final titlesValid = _days.every((day) => day.titleController.text.trim().isNotEmpty);

    if (!formValid || !datesValid || !titlesValid || _days.isEmpty) {
      setState(() {
        _errorMessage = l10n.plansEditorValidationError;
      });
      return;
    }

    final payload = TrainingPlanUpsertPayload(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: _startDate!,
      stravaEvaluationStartDate: _stravaEvaluationStartDate ?? _startDate,
      planType: _planType,
      trainingDays: _days
          .map(
            (day) => TrainingDayUpsertPayload(
              scheduledDate: day.scheduledDate!,
              title: day.titleController.text.trim(),
              activityType: day.activityType,
              plannedDistanceMeters: _parseNullableInt(day.distanceController.text),
              plannedDurationSeconds: _parseNullableInt(day.durationController.text),
              notes: day.notesController.text.trim(),
            ),
          )
          .toList(),
    );

    setState(() {
      _saving = true;
      _errorMessage = '';
    });

    try {
      if (widget.isEditMode) {
        await widget.repository.updatePlan(widget.planId!, payload);
      } else {
        await widget.repository.createPlan(payload);
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditMode
                ? l10n.plansUpdatedSnackbar(payload.name)
                : l10n.plansCreatedSnackbar(payload.name),
          ),
        ),
      );
      context.go('/plans');
    } on ApiException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
    } catch (_) {
      setState(() {
        _errorMessage = widget.isEditMode
            ? 'Nie udalo sie zapisac zmian planu.'
            : 'Nie udalo sie utworzyc planu.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  int? _parseNullableInt(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    return int.tryParse(trimmed);
  }
}

class _EditorHeader extends StatelessWidget {
  const _EditorHeader({required this.isEditMode});

  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.plansEditorKicker.toUpperCase(),
              style: const TextStyle(
                color: AppColors.accentDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isEditMode ? l10n.plansEditTitle : l10n.plansCreateTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isEditMode
                  ? l10n.plansEditSubtitle
                  : l10n.plansCreateSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainingDayEditorCard extends StatelessWidget {
  const _TrainingDayEditorCard({
    required this.index,
    required this.day,
    required this.onDateSelected,
    required this.onActivityChanged,
    this.onRemove,
    this.onMoveUp,
    this.onMoveDown,
    super.key,
  });

  final int index;
  final _EditableTrainingDay day;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<ActivityType> onActivityChanged;
  final VoidCallback? onRemove;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l10n.plansDayPrefix} ${index + 1}',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: onMoveUp,
                icon: const Icon(Icons.keyboard_arrow_up_rounded),
              ),
              IconButton(
                onPressed: onMoveDown,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
              IconButton(
                onPressed: onRemove,
                color: AppColors.danger,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _DatePickerField(
            label: l10n.plansEditorDayDate,
            value: day.scheduledDate,
            required: true,
            onSelected: onDateSelected,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: day.titleController,
            decoration: InputDecoration(labelText: l10n.plansEditorDayTitle),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.requiredField;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ActivityType>(
            initialValue: day.activityType,
            decoration: InputDecoration(labelText: l10n.plansEditorDayActivityType),
            items: ActivityType.values
                .map(
                  (type) => DropdownMenuItem<ActivityType>(
                    value: type,
                    child: Text(activityTypeLabel(context, type)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onActivityChanged(value);
              }
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: day.distanceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.plansEditorDayDistance,
                    hintText: '5000',
                  ),
                  validator: (value) => _validateOptionalNumber(value, l10n),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: day.durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.plansEditorDayDuration,
                    hintText: '1800',
                  ),
                  validator: (value) => _validateOptionalNumber(value, l10n),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: day.notesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: l10n.plansEditorDayNotes,
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  String? _validateOptionalNumber(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }

    final parsed = int.tryParse(trimmed);
    if (parsed == null || parsed < 0) {
      return l10n.plansEditorInvalidNumber;
    }

    return null;
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.onSelected,
    this.value,
    this.required = false,
  });

  final String label;
  final DateTime? value;
  final bool required;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () async {
        final now = DateTime.now();
        final initialDate = value ?? now;
        final firstDate = DateTime(now.year - 5);
        final lastDate = DateTime(now.year + 10);
        final selected = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if (selected != null) {
          onSelected(selected);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
        ),
        child: Text(
          value == null ? '-' : _formatDate(value!),
          style: TextStyle(
            color: value == null ? AppColors.muted : AppColors.text,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString().padLeft(4, '0');
    return '$day.$month.$year';
  }
}

class _EditorErrorBanner extends StatelessWidget {
  const _EditorErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withOpacity(0.18)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: AppColors.danger,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EditableTrainingDay {
  _EditableTrainingDay({
    required this.localId,
    required this.titleController,
    required this.distanceController,
    required this.durationController,
    required this.notesController,
    required this.activityType,
    this.scheduledDate,
  });

  final int localId;
  final TextEditingController titleController;
  final TextEditingController distanceController;
  final TextEditingController durationController;
  final TextEditingController notesController;
  ActivityType activityType;
  DateTime? scheduledDate;

  factory _EditableTrainingDay.empty(int localId) {
    return _EditableTrainingDay(
      localId: localId,
      titleController: TextEditingController(),
      distanceController: TextEditingController(),
      durationController: TextEditingController(),
      notesController: TextEditingController(),
      activityType: ActivityType.run,
    );
  }

  factory _EditableTrainingDay.fromPlanDay(TrainingDay day) {
    final localId = day.id ?? Object.hash(day.title, day.scheduledDate);
    return _EditableTrainingDay(
      localId: localId,
      titleController: TextEditingController(text: day.title),
      distanceController: TextEditingController(
        text: day.plannedDistanceMeters?.toString() ?? '',
      ),
      durationController: TextEditingController(
        text: day.plannedDurationSeconds?.toString() ?? '',
      ),
      notesController: TextEditingController(text: day.notes ?? ''),
      activityType: day.activityType,
      scheduledDate: day.scheduledDate,
    );
  }

  void dispose() {
    titleController.dispose();
    distanceController.dispose();
    durationController.dispose();
    notesController.dispose();
  }
}
