import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/networking/api_exception.dart';
import '../../../shared/models/activity_type.dart';
import '../../../shared/utils/activity_type_labels.dart';
import '../../../shared/utils/metric_formatters.dart';
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
  TrainingPlan? _importPreview;
  String _importedFileName = '';
  bool _importLoading = false;
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
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 108),
            children: [
              _EditorHeader(isEditMode: widget.isEditMode),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                _EditorErrorBanner(message: l10n.resolveError(_errorMessage)),
              ],
              if (!widget.isEditMode) ...[
                const SizedBox(height: 16),
                _ImportCard(
                  fileName: _importedFileName,
                  importLoading: _importLoading,
                  preview: _importPreview,
                  onPickFile: _pickJsonFile,
                  onApplyImport: _importPreview == null ? null : _applyImportPreview,
                ),
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
          Positioned(
            right: 20,
            bottom: 20,
            child: SafeArea(
              top: false,
              child: FloatingActionButton.extended(
                onPressed: _addDay,
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.white,
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.plansEditorAddDay),
              ),
            ),
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
      _errorMessage = error.code ?? error.message;
    } catch (_) {
      _errorMessage = 'errorPlanLoad';
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
        _errorMessage = error.code ?? error.message;
      });
    } catch (_) {
      setState(() {
        _errorMessage = widget.isEditMode
            ? 'errorPlanUpdate'
            : 'errorPlanCreate';
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _pickJsonFile() async {
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();

    setState(() {
      _importLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: true,
      );

      if (!mounted) {
        return;
      }

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.single;
      final fileName = file.name;
      if (!fileName.toLowerCase().endsWith('.json')) {
        setState(() {
          _errorMessage = l10n.plansImportInvalidFile;
        });
        return;
      }

      String? content;
      if (file.bytes != null) {
        content = utf8.decode(file.bytes!);
      } else if (file.path != null) {
        content = await File(file.path!).readAsString();
      }

      if (content == null || content.trim().isEmpty) {
        setState(() {
          _errorMessage = l10n.plansImportReadError;
        });
        return;
      }

      final imported = _parseImportedPlan(content);
      final validationError = _validateImportedPlan(imported);
      if (validationError != null) {
        setState(() {
          _errorMessage = validationError;
          _importPreview = null;
          _importedFileName = fileName;
        });
        return;
      }

      setState(() {
        _importPreview = imported.plan;
        _importedFileName = fileName;
        _errorMessage = '';
      });
    } on FormatException {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = l10n.plansImportInvalidJson;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = l10n.plansImportReadError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _importLoading = false;
        });
      }
    }
  }

  _ImportedPlanData _parseImportedPlan(String content) {
    final decoded = jsonDecode(content);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException();
    }

    return _ImportedPlanData(
      rawJson: decoded,
      plan: TrainingPlan.fromJson(decoded),
    );
  }

  String? _validateImportedPlan(_ImportedPlanData imported) {
    final l10n = AppLocalizations.of(context);
    final plan = imported.plan;
    final raw = imported.rawJson;

    if (plan.name.trim().isEmpty ||
        plan.startDate == null ||
        plan.trainingDays.isEmpty) {
      return l10n.plansImportValidationError;
    }

    final rawPlanType = raw['planType'];
    final validPlanType = rawPlanType is String &&
        ActivityType.values.any((type) => type.apiValue == rawPlanType);
    if (!validPlanType) {
      return l10n.plansImportValidationError;
    }

    final rawDays = raw['trainingDays'];
    if (rawDays is! List || rawDays.isEmpty) {
      return l10n.plansImportValidationError;
    }

    final hasInvalidDay = plan.trainingDays.any(
      (day) =>
          day.scheduledDate == null ||
          day.title.trim().isEmpty,
    );
    if (hasInvalidDay) {
      return l10n.plansImportValidationError;
    }

    for (var index = 0; index < rawDays.length; index++) {
      final day = rawDays[index];
      if (day is! Map<String, dynamic>) {
        return l10n.plansImportValidationError;
      }

      final rawActivityType = day['activityType'];
      final validDayActivityType = rawActivityType is String &&
          ActivityType.values.any((type) => type.apiValue == rawActivityType);
      if (!validDayActivityType) {
        return l10n.plansImportValidationError;
      }

      final plannedDistance = day['plannedDistanceMeters'];
      if (plannedDistance is num && plannedDistance < 0) {
        return l10n.plansImportValidationError;
      }

      final plannedDuration = day['plannedDurationSeconds'];
      if (plannedDuration is num && plannedDuration < 0) {
        return l10n.plansImportValidationError;
      }
    }

    return null;
  }

  void _applyImportPreview() {
    final l10n = AppLocalizations.of(context);
    final preview = _importPreview;
    if (preview == null) {
      return;
    }

    setState(() {
      _nameController.text = preview.name;
      _descriptionController.text = preview.description ?? '';
      _startDate = preview.startDate;
      _stravaEvaluationStartDate =
          preview.stravaEvaluationStartDate ?? preview.startDate;
      _planType = preview.planType;
      _replaceDays(
        preview.trainingDays
            .map(_EditableTrainingDay.fromPlanDay)
            .toList(),
      );
      _errorMessage = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.plansImportApplied)),
    );
  }

  int? _parseNullableInt(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    return int.tryParse(trimmed);
  }
}

class _ImportCard extends StatelessWidget {
  const _ImportCard({
    required this.fileName,
    required this.importLoading,
    required this.preview,
    required this.onPickFile,
    required this.onApplyImport,
  });

  final String fileName;
  final bool importLoading;
  final TrainingPlan? preview;
  final Future<void> Function() onPickFile;
  final VoidCallback? onApplyImport;

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
              l10n.plansEditorSectionImport.toUpperCase(),
              style: const TextStyle(
                color: AppColors.accentDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.plansImportTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.plansImportDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: importLoading ? null : onPickFile,
              icon: importLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.upload_file_rounded),
              label: Text(l10n.plansImportPickFile),
            ),
            if (fileName.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '${l10n.plansImportSelectedFile}: $fileName',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: 16),
            if (preview == null)
              Text(
                l10n.plansImportNoPreview,
                style: Theme.of(context).textTheme.bodyLarge,
              )
            else
              _ImportPreviewCard(preview: preview!),
            if (preview != null) ...[
              const SizedBox(height: 16),
              Text(
                l10n.plansImportReplaceNotice,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onApplyImport,
                icon: const Icon(Icons.playlist_add_check_rounded),
                label: Text(l10n.plansImportApply),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImportPreviewCard extends StatelessWidget {
  const _ImportPreviewCard({required this.preview});

  final TrainingPlan preview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.plansImportPreviewTitle,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            preview.name,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (preview.description?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: 8),
            Text(
              preview.description!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _PreviewMetaChip(
                label: l10n.plansImportPreviewType,
                value: activityTypeLabel(context, preview.planType),
              ),
              _PreviewMetaChip(
                label: l10n.plansImportPreviewDays,
                value: preview.trainingDays.length.toString(),
              ),
              _PreviewMetaChip(
                label: l10n.plansImportPreviewStart,
                value: _formatDate(preview.startDate),
              ),
              _PreviewMetaChip(
                label: l10n.plansImportPreviewStravaStart,
                value: _formatDate(
                  preview.stravaEvaluationStartDate ?? preview.startDate,
                ),
              ),
            ],
          ),
          if (preview.trainingDays.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.plansImportPreviewDaysSection,
              style: const TextStyle(
                color: AppColors.accentDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),
            for (final day in preview.trainingDays.take(3)) ...[
              _ImportPreviewDayCard(day: day),
              if (day != preview.trainingDays.take(3).last)
                const SizedBox(height: 8),
            ],
            if (preview.trainingDays.length > 3) ...[
              const SizedBox(height: 10),
              Text(
                l10n.plansImportPreviewMoreDays(
                  preview.trainingDays.length - 3,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');
    return '$day.$month.$year';
  }
}

class _ImportPreviewDayCard extends StatelessWidget {
  const _ImportPreviewDayCard({required this.day});

  final TrainingDay day;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatDate(day.scheduledDate)} • ${activityTypeLabel(context, day.activityType)}',
            style: const TextStyle(color: AppColors.muted),
          ),
          if (day.plannedDistanceMeters != null ||
              day.plannedDurationSeconds != null) ...[
            const SizedBox(height: 6),
            Text(
              '${formatDistanceKm(day.plannedDistanceMeters)} / ${formatDurationShort(day.plannedDurationSeconds)}',
              style: const TextStyle(color: AppColors.text),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');
    return '$day.$month.$year';
  }
}

class _PreviewMetaChip extends StatelessWidget {
  const _PreviewMetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportedPlanData {
  const _ImportedPlanData({required this.rawJson, required this.plan});

  final Map<String, dynamic> rawJson;
  final TrainingPlan plan;
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
