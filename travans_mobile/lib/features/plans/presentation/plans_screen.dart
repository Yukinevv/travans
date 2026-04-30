import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/models/training_day_status.dart';
import '../../../shared/utils/activity_type_labels.dart';
import '../../../shared/utils/metric_formatters.dart';
import '../../../shared/utils/training_day_status_labels.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../application/plans_controller.dart';
import '../data/plan_models.dart';

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  int? _expandedPlanId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(plansControllerProvider);

    if (state.loading && state.plans.isEmpty) {
      return Center(child: LoadingView(label: l10n.plansLoading));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(plansControllerProvider.notifier).reload(),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _PlansHeader(planCount: state.plans.length),
          if (state.errorMessage.isNotEmpty && state.plans.isEmpty) ...[
            const SizedBox(height: 16),
            ErrorView(
              message: state.errorMessage,
              onRetry: () => ref.read(plansControllerProvider.notifier).reload(),
            ),
          ] else if (state.errorMessage.isNotEmpty) ...[
            const SizedBox(height: 16),
            _InlineErrorBanner(message: state.errorMessage),
          ],
          if (state.plans.isEmpty && !state.loading && state.errorMessage.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: EmptyState(
                icon: Icons.event_note_outlined,
                title: l10n.plansEmptyTitle,
                message: l10n.plansEmptyDescription,
              ),
            )
          else ...[
            const SizedBox(height: 16),
            for (final plan in state.plans) ...[
              _PlanCard(
                plan: plan,
                expanded: _expandedPlanId == plan.id,
                pinnedToDashboard: state.selectedDashboardPlanId == plan.id,
                deleting: state.deletingPlanId == plan.id,
                onToggle: () {
                  setState(() {
                    _expandedPlanId = _expandedPlanId == plan.id ? null : plan.id;
                  });
                },
                onPin: () => _confirmPin(plan),
                onDelete: () => _confirmDelete(plan),
              ),
              const SizedBox(height: 14),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _confirmPin(TrainingPlan plan) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.plansPinDialogTitle),
        content: Text(l10n.plansPinDialogMessage(plan.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.plansCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.plansShowOnDashboard),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await ref.read(plansControllerProvider.notifier).pinToDashboard(plan.id);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.plansPinnedSnackbar(plan.name))),
    );
  }

  Future<void> _confirmDelete(TrainingPlan plan) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.plansDeleteDialogTitle),
        content: Text(l10n.plansDeleteDialogMessage(plan.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.plansCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.plansDelete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final error = await ref.read(plansControllerProvider.notifier).deletePlan(
      plan.id,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? l10n.plansDeletedSnackbar(plan.name)),
        backgroundColor: error == null ? null : AppColors.danger,
      ),
    );
  }
}

class _PlansHeader extends StatelessWidget {
  const _PlansHeader({required this.planCount});

  final int planCount;

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
              l10n.plansHeaderKicker.toUpperCase(),
              style: const TextStyle(
                color: AppColors.accentDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.plansHeaderTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.plansHeaderSubtitle(planCount),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.expanded,
    required this.pinnedToDashboard,
    required this.deleting,
    required this.onToggle,
    required this.onPin,
    required this.onDelete,
  });

  final TrainingPlan plan;
  final bool expanded;
  final bool pinnedToDashboard;
  final bool deleting;
  final VoidCallback onToggle;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  plan.name,
                                  style: const TextStyle(
                                    color: AppColors.text,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (pinnedToDashboard)
                                _Badge(
                                  label: l10n.plansVisibleOnDashboard,
                                  color: AppColors.success,
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _MetaChip(
                                label: l10n.plansTypeLabel,
                                value: activityTypeLabel(context, plan.planType),
                              ),
                              _MetaChip(
                                label: l10n.plansDaysLabel,
                                value: plan.trainingDays.length.toString(),
                              ),
                              _MetaChip(
                                label: l10n.plansStartDateLabel,
                                value: _formatDate(plan.startDate),
                              ),
                              _MetaChip(
                                label: 'Strava',
                                value: _formatDate(
                                  plan.stravaEvaluationStartDate ?? plan.startDate,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    IconButton(
                      onPressed: onToggle,
                      icon: AnimatedRotation(
                        turns: expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: pinnedToDashboard ? null : onPin,
                        icon: const Icon(Icons.push_pin_outlined),
                        label: Text(
                          pinnedToDashboard
                              ? l10n.plansVisibleOnDashboard
                              : l10n.plansShowOnDashboard,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filledTonal(
                      onPressed: deleting ? null : onDelete,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.danger.withOpacity(0.12),
                        foregroundColor: AppColors.danger,
                      ),
                      icon: deleting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.delete_outline_rounded),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 220),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (plan.createdAt != null)
                          _SectionCard(
                            label: l10n.plansCreatedAtLabel,
                            child: Text(
                              _formatDateTime(plan.createdAt),
                              style: const TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        if (plan.createdAt != null) const SizedBox(height: 12),
                        if (plan.description?.trim().isNotEmpty ?? false) ...[
                          _SectionCard(
                            label: l10n.plansDescriptionLabel,
                            child: Text(plan.description!),
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (plan.trainingDays.isEmpty)
                          _SectionCard(
                            label: l10n.plansDaysSection,
                            child: Text(l10n.plansNoTrainingDays),
                          )
                        else ...[
                          Text(
                            l10n.plansDaysSection,
                            style: const TextStyle(
                              color: AppColors.accentDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (var index = 0; index < plan.trainingDays.length; index++)
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: index == plan.trainingDays.length - 1 ? 0 : 10,
                              ),
                              child: _TrainingDayPreviewCard(
                                day: plan.trainingDays[index],
                                index: index,
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) {
      return '-';
    }

    final datePart = _formatDate(date);
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$datePart $hour:$minute';
  }
}

class _TrainingDayPreviewCard extends StatelessWidget {
  const _TrainingDayPreviewCard({required this.day, required this.index});

  final TrainingDay day;
  final int index;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.plansDayPrefix} ${index + 1}: ${day.title}',
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_formatDate(day.scheduledDate)} | ${activityTypeLabel(context, day.activityType)}',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _Badge(
                label: trainingDayStatusLabel(context, day.status),
                color: _statusColor(day.status),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: l10n.plansDistanceLabel,
                  primary: formatDistanceKm(day.plannedDistanceMeters),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  label: l10n.plansDurationLabel,
                  primary: formatDurationShort(day.plannedDurationSeconds),
                ),
              ),
            ],
          ),
          if (day.notes?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: 12),
            _SectionCard(
              label: l10n.plansNotesLabel,
              child: Text(day.notes!),
            ),
          ],
          if (day.matchedActivityName?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: 12),
            _SectionCard(
              label: l10n.plansMatchedActivityLabel,
              child: Text(
                '${day.matchedActivityName!}'
                '${day.matchedActivityDate != null ? ' (${_formatDate(day.matchedActivityDate)})' : ''}',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(TrainingDayStatus status) {
    switch (status) {
      case TrainingDayStatus.completed:
        return AppColors.success;
      case TrainingDayStatus.partiallyCompleted:
        return AppColors.warn;
      case TrainingDayStatus.missed:
        return AppColors.danger;
      case TrainingDayStatus.planned:
        return AppColors.accentDark;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _InlineErrorBanner extends StatelessWidget {
  const _InlineErrorBanner({required this.message});

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

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
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

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.primary});

  final String label;
  final String primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            primary,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
