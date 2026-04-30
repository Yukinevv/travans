import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/models/activity_type.dart';
import '../../../shared/models/training_day_status.dart';
import '../../../shared/utils/activity_type_labels.dart';
import '../../../shared/utils/metric_formatters.dart';
import '../../../shared/utils/training_day_status_labels.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../plans/data/plan_models.dart';
import '../application/dashboard_controller.dart';
import '../application/dashboard_state.dart';
import '../data/dashboard_models.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int? _expandedDayId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(dashboardControllerProvider);

    if (state.loading && state.summary == null && state.plans.isEmpty) {
      return Center(child: LoadingView(label: l10n.dashboardLoading));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardControllerProvider.notifier).reload(),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _DashboardHeader(state: state),
          if (state.loading && state.summary != null) ...[
            const SizedBox(height: 16),
            Center(child: LoadingView(label: l10n.dashboardLoading)),
          ],
          if (state.errorMessage.isNotEmpty) ...[
            const SizedBox(height: 16),
            ErrorView(
              message: state.errorMessage,
              onRetry: () =>
                  ref.read(dashboardControllerProvider.notifier).reload(),
            ),
          ],
          if (state.summary != null) ...[
            const SizedBox(height: 16),
            _buildStatsGrid(context, state.summary!),
            const SizedBox(height: 16),
            _EffectivenessCard(summary: state.summary!),
            if (state.summary!.currentPlanId == null) ...[
              const SizedBox(height: 16),
              EmptyState(
                icon: Icons.flag_outlined,
                title: l10n.dashboardCurrentPlanEmptyTitle,
                message: l10n.dashboardCurrentPlanEmptyDescription,
              ),
            ] else ...[
              const SizedBox(height: 16),
              _DetailedStatsCard(summary: state.summary!),
              const SizedBox(height: 16),
              _CurrentPlanCard(
                summary: state.summary!,
                expandedDayId: _expandedDayId,
                onToggleDay: (day) {
                  setState(() {
                    final key = _dayKey(day);
                    _expandedDayId = _expandedDayId == key ? null : key;
                  });
                },
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, DashboardSummary summary) {
    final l10n = AppLocalizations.of(context);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _StatCard(
          label: l10n.dashboardStatsPlanned,
          value: summary.totalPlanned.toString(),
        ),
        _StatCard(
          label: l10n.dashboardStatsCompleted,
          value: summary.completed.toString(),
          accentColor: AppColors.success,
        ),
        _StatCard(
          label: l10n.dashboardStatsPartial,
          value: summary.partiallyCompleted.toString(),
          accentColor: AppColors.warn,
        ),
        _StatCard(
          label: l10n.dashboardStatsMissed,
          value: summary.missed.toString(),
          accentColor: AppColors.danger,
        ),
      ],
    );
  }

  int _dayKey(TrainingDay day) {
    return day.id ?? Object.hash(day.title, day.scheduledDate?.toIso8601String());
  }
}

class _DashboardHeader extends ConsumerWidget {
  const _DashboardHeader({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardHeaderKicker.toUpperCase(),
              style: const TextStyle(
                color: AppColors.accentDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.dashboardHeaderTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<int?>(
              isExpanded: true,
              value: state.selectedPlanId,
              decoration: InputDecoration(labelText: l10n.dashboardDisplayedPlan),
              items: [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text(
                    l10n.dashboardAutoSelect,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                for (final plan in state.plans)
                  DropdownMenuItem<int?>(
                    value: plan.id,
                    child: Text(
                      plan.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: state.loadingPlans
                  ? null
                  : (value) {
                      ref
                          .read(dashboardControllerProvider.notifier)
                          .selectPlan(value);
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _EffectivenessCard extends StatelessWidget {
  const _EffectivenessCard({required this.summary});

  final DashboardSummary summary;

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
              l10n.dashboardStatsEffectiveness.toUpperCase(),
              style: const TextStyle(
                color: AppColors.accentDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              '${summary.completionRate.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 12,
                value: (summary.completionRate / 100).clamp(0, 1),
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailedStatsCard extends StatelessWidget {
  const _DetailedStatsCard({required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stats = summary.detailedStats;
    final cards = [
      _MiniStatCard(
        label: l10n.dashboardDaysMeetingDistanceGoal,
        value: stats.daysMeetingDistanceGoal.toString(),
      ),
      _MiniStatCard(
        label: l10n.dashboardDaysMeetingDurationGoal,
        value: stats.daysMeetingDurationGoal.toString(),
      ),
      _MiniStatCard(
        label: l10n.dashboardDaysMeetingPaceGoal,
        value: stats.daysMeetingPaceGoal.toString(),
      ),
      _MiniStatCard(
        label: l10n.dashboardOverDistance,
        value: formatDistanceKm(stats.totalDistanceOverMeters),
      ),
      _MiniStatCard(
        label: l10n.dashboardOverDuration,
        value: formatDurationShort(stats.totalDurationOverSeconds),
      ),
      _MiniStatCard(
        label: l10n.dashboardSavedTime,
        value: formatDurationShort(stats.totalTimeSavedSeconds),
      ),
      if (summary.currentPlanType == ActivityType.run ||
          summary.currentPlanType == ActivityType.walk)
        _MiniStatCard(
          label: l10n.dashboardAverageRunPace,
          value: formatPaceFromSecondsPerKm(
            stats.averageRunPaceSecondsPerKm,
          ),
        ),
      if (summary.currentPlanType == ActivityType.run ||
          summary.currentPlanType == ActivityType.walk)
        _MiniStatCard(
          label: l10n.dashboardFastestRunPace,
          value: formatPaceFromSecondsPerKm(
            stats.fastestRunPaceSecondsPerKm,
          ),
        ),
      if (summary.currentPlanType == ActivityType.ride)
        _MiniStatCard(
          label: l10n.dashboardAverageRideSpeed,
          value: formatSpeedKphValue(stats.averageRideSpeedKph),
        ),
      if (summary.currentPlanType == ActivityType.ride)
        _MiniStatCard(
          label: l10n.dashboardMaxRideSpeed,
          value: formatSpeedKphValue(stats.topRideSpeedKph),
        ),
      _MiniStatCard(
        label: l10n.dashboardElevationGain,
        value: '${stats.totalElevationGainMeters} m',
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardDetailsLabel.toUpperCase(),
              style: const TextStyle(
                color: AppColors.accentDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth < 260 ? 1 : 2;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cards.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: crossAxisCount == 1 ? 116 : 132,
                  ),
                  itemBuilder: (context, index) => cards[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentPlanCard extends StatelessWidget {
  const _CurrentPlanCard({
    required this.summary,
    required this.expandedDayId,
    required this.onToggleDay,
  });

  final DashboardSummary summary;
  final int? expandedDayId;
  final ValueChanged<TrainingDay> onToggleDay;

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
              l10n.dashboardCurrentPlanLabel.toUpperCase(),
              style: const TextStyle(
                color: AppColors.accentDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              summary.currentPlanName ?? '-',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (summary.currentPlanType != null) ...[
              const SizedBox(height: 6),
              Text(
                '${l10n.dashboardPlanTypePrefix} ${activityTypeLabel(context, summary.currentPlanType!)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            if (summary.selectedPlanPinnedMessageNeeded) ...[
              const SizedBox(height: 6),
              Text(
                l10n.dashboardPinnedMessage,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: 20),
            if (summary.trainingDays.isEmpty)
              EmptyState(
                icon: Icons.calendar_month_outlined,
                title: l10n.emptyStateTitle,
                message: l10n.dashboardNoTrainingDays,
              )
            else
              for (final day in summary.trainingDays) ...[
                _TrainingDayCard(
                  day: day,
                  expanded: expandedDayId == _dayKey(day),
                  onToggle: () => onToggleDay(day),
                ),
                const SizedBox(height: 12),
              ],
          ],
        ),
      ),
    );
  }

  int _dayKey(TrainingDay day) {
    return day.id ?? Object.hash(day.title, day.scheduledDate?.toIso8601String());
  }
}

class _TrainingDayCard extends StatelessWidget {
  const _TrainingDayCard({
    required this.day,
    required this.expanded,
    required this.onToggle,
  });

  final TrainingDay day;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detailCards = [
      _DetailMetricCard(
        label: l10n.dashboardDistanceGoal,
        value: _goalLabel(context, day.distanceGoalMet),
      ),
      _DetailMetricCard(
        label: l10n.dashboardDurationGoal,
        value: _goalLabel(context, day.durationGoalMet),
      ),
      _DetailMetricCard(
        label: l10n.dashboardPaceGoal,
        value: _goalLabel(context, day.paceGoalMet),
      ),
      if (day.matchedAverageSpeedMetersPerSecond != null)
        _DetailMetricCard(
          label: l10n.dashboardAverageSpeed,
          value: formatSpeedKph(day.matchedAverageSpeedMetersPerSecond),
        ),
      if (day.matchedMaxSpeedMetersPerSecond != null)
        _DetailMetricCard(
          label: l10n.dashboardMaxSpeed,
          value: formatSpeedKph(day.matchedMaxSpeedMetersPerSecond),
        ),
      if (day.matchedElevationGainMeters != null)
        _DetailMetricCard(
          label: l10n.dashboardElevationGain,
          value: '${day.matchedElevationGainMeters} m',
        ),
      if (day.matchedAverageHeartrateBpm != null)
        _DetailMetricCard(
          label: l10n.dashboardAverageHeartrate,
          value: '${day.matchedAverageHeartrateBpm!.round()} bpm',
        ),
      if (day.matchedMaxHeartrateBpm != null)
        _DetailMetricCard(
          label: l10n.dashboardMaxHeartrate,
          value: '${day.matchedMaxHeartrateBpm} bpm',
        ),
      if (day.matchedAverageCadenceRpm != null)
        _DetailMetricCard(
          label: l10n.dashboardAverageCadence,
          value: '${day.matchedAverageCadenceRpm!.round()}',
        ),
      if (day.distanceOverMeters != null && day.distanceOverMeters! > 0)
        _DetailMetricCard(
          label: l10n.dashboardOverDistance,
          value: formatDistanceKm(day.distanceOverMeters),
        ),
      if (day.durationOverSeconds != null && day.durationOverSeconds! > 0)
        _DetailMetricCard(
          label: l10n.dashboardOverDuration,
          value: formatDurationShort(day.durationOverSeconds),
        ),
      if (day.timeSavedSeconds != null && day.timeSavedSeconds! > 0)
        _DetailMetricCard(
          label: l10n.dashboardSavedTime,
          value: formatDurationShort(day.timeSavedSeconds),
        ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                            day.title,
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${_formatDate(day.scheduledDate)} • ${activityTypeLabel(context, day.activityType)}',
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _StatusChip(status: day.status),
                        const SizedBox(height: 10),
                        AnimatedRotation(
                          turns: expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
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
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _OverviewCard(
                                label: l10n.dashboardScheduledFor,
                                primary: _formatWeekdayDate(day.scheduledDate),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _OverviewCard(
                                label: l10n.dashboardActivity,
                                primary: activityTypeLabel(
                                  context,
                                  day.activityType,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _OverviewCard(
                                label: l10n.dashboardPlannedSection,
                                primary: formatDistanceKm(
                                  day.plannedDistanceMeters,
                                ),
                                secondary: formatDurationShort(
                                  day.plannedDurationSeconds,
                                ),
                              ),
                            ),
                            if (day.matchedActivityId != null) ...[
                              const SizedBox(width: 10),
                              Expanded(
                                child: _OverviewCard(
                                  label: l10n.dashboardCompletedSection,
                                  primary: formatDistanceKm(
                                    day.matchedDistanceMeters,
                                  ),
                                  secondary: formatDurationShort(
                                    day.matchedMovingTimeSeconds,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (day.matchedActivityId != null) ...[
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${l10n.dashboardMatchedActivity} ${day.matchedActivityName ?? ''}'
                              '${day.matchedActivityDate != null ? ' (${_formatDate(day.matchedActivityDate)})' : ''}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                        if (day.notes?.trim().isNotEmpty ?? false) ...[
                          const SizedBox(height: 14),
                          _NoteBlock(notes: day.notes!),
                        ],
                        if (detailCards.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          _DetailMetricsGrid(cards: detailCards),
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

  String _goalLabel(BuildContext context, bool? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null) {
      return l10n.dashboardNoCriteria;
    }
    return value ? l10n.dashboardGoalAchieved : l10n.dashboardGoalNotAchieved;
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatWeekdayDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    const weekdays = ['pon', 'wt', 'sr', 'czw', 'pt', 'sob', 'niedz'];
    final weekday = weekdays[(date.weekday - 1).clamp(0, 6)];
    return '$weekday, ${_formatDate(date)}';
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.accentColor = AppColors.accent,
  });

  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            Text(
              value,
              style: TextStyle(
                color: accentColor,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final TrainingDayStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      TrainingDayStatus.completed => AppColors.success,
      TrainingDayStatus.partiallyCompleted => AppColors.warn,
      TrainingDayStatus.missed => AppColors.danger,
      TrainingDayStatus.planned => AppColors.accentDark,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        trainingDayStatusLabel(context, status),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.label,
    required this.primary,
    this.secondary,
  });

  final String label;
  final String primary;
  final String? secondary;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            primary,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (secondary != null) ...[
            const SizedBox(height: 4),
            Text(
              secondary!,
              style: const TextStyle(color: AppColors.muted, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}

class _NoteBlock extends StatelessWidget {
  const _NoteBlock({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
            l10n.dashboardNotes,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(notes, style: const TextStyle(color: AppColors.text)),
        ],
      ),
    );
  }
}

class _DetailMetricsGrid extends StatelessWidget {
  const _DetailMetricsGrid({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useSingleColumn = constraints.maxWidth < 260;
        if (useSingleColumn) {
          return Column(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                cards[i],
                if (i < cards.length - 1) const SizedBox(height: 10),
              ],
            ],
          );
        }

        final rows = <Widget>[];
        for (var i = 0; i < cards.length; i += 2) {
          final left = cards[i];
          final right = i + 1 < cards.length ? cards[i + 1] : null;

          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 10),
                Expanded(child: right ?? const SizedBox.shrink()),
              ],
            ),
          );
        }

        return Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              rows[i],
              if (i < rows.length - 1) const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }
}

class _DetailMetricCard extends StatelessWidget {
  const _DetailMetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            value,
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

extension on DashboardSummary {
  bool get selectedPlanPinnedMessageNeeded => currentPlanId != null;
}
