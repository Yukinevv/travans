import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/networking/api_exception.dart';
import '../../../shared/models/activity_type.dart';
import '../../../shared/utils/activity_type_labels.dart';
import '../../../shared/utils/metric_formatters.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../data/strava_models.dart';
import '../data/strava_repository.dart';

class ActivityDetailScreen extends ConsumerStatefulWidget {
  const ActivityDetailScreen({required this.activityId, super.key});

  final int activityId;

  @override
  ConsumerState<ActivityDetailScreen> createState() =>
      _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends ConsumerState<ActivityDetailScreen> {
  StravaActivity? _activity;
  String _errorMessage = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadActivity();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Center(child: LoadingView(label: l10n.loading));
    }

    if (_errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: ErrorView(message: _errorMessage, onRetry: _loadActivity),
      );
    }

    final activity = _activity;
    if (activity == null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: ErrorView(
          message: l10n.integrationsActivityLoadError,
          onRetry: _loadActivity,
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(activity.name, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          '${_formatDate(activity.activityDate)} / ${activityTypeLabel(context, activity.activityType)}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _MetricCard(
              label: l10n.integrationsDistance,
              value: formatDistanceKm(activity.distanceMeters),
            ),
            _MetricCard(
              label: l10n.integrationsDuration,
              value: formatDurationShort(activity.movingTimeSeconds),
            ),
            _MetricCard(
              label: l10n.integrationsAverageSpeed,
              value: formatSpeedKph(activity.averageSpeedMetersPerSecond),
            ),
            if (activity.activityType == ActivityType.run ||
                activity.activityType == ActivityType.walk)
              _MetricCard(
                label: l10n.integrationsAveragePace,
                value: formatPace(activity.averageSpeedMetersPerSecond),
              ),
            if (activity.elevationGainMeters != null)
              _MetricCard(
                label: l10n.integrationsElevation,
                value: '${activity.elevationGainMeters} m',
              ),
            if (activity.averageHeartrateBpm != null)
              _MetricCard(
                label: l10n.integrationsHeartRate,
                value: '${activity.averageHeartrateBpm!.round()} bpm',
              ),
          ],
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.integrationsMatchSection,
                  style: const TextStyle(
                    color: AppColors.accentDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                if (activity.matchedToPlan) ...[
                  Text(
                    activity.matchedTrainingDayTitle ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activity.matchedPlanName ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ] else
                  Text(
                    l10n.integrationsUnmatchedDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _loadActivity() async {
    setState(() {
      _loading = true;
    });

    try {
      final activity = await ref
          .read(stravaRepositoryProvider)
          .getActivity(widget.activityId);

      if (!mounted) {
        return;
      }

      setState(() {
        _activity = activity;
        _errorMessage = '';
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = _readableMessage(error);
        _loading = false;
      });
    }
  }

  String _readableMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return error.toString().replaceFirst('Exception: ', '');
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 164,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
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
      ),
    );
  }
}
