import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/networking/api_exception.dart';
import '../../../shared/models/activity_type.dart';
import '../../../shared/utils/activity_type_labels.dart';
import '../../../shared/utils/metric_formatters.dart';
import '../../../shared/widgets/loading_view.dart';
import '../data/strava_models.dart';
import '../data/strava_repository.dart';

class IntegrationsScreen extends ConsumerStatefulWidget {
  const IntegrationsScreen({super.key});

  @override
  ConsumerState<IntegrationsScreen> createState() => _IntegrationsScreenState();
}

class _IntegrationsScreenState extends ConsumerState<IntegrationsScreen> {
  StreamSubscription<Uri>? _deepLinkSubscription;
  StravaConnectionStatus? _status;
  StravaSyncResult? _syncResult;
  List<StravaActivity> _activities = const [];
  ActivityType? _selectedActivityType;
  String _errorMessage = '';
  bool _loading = true;
  bool _activitiesLoading = false;
  bool _syncInProgress = false;

  @override
  void initState() {
    super.initState();
    _listenForDeepLinks();
    _handleInitialDeepLink();
    _loadStatus();
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return const Center(child: LoadingView());
    }

    return RefreshIndicator(
      onRefresh: _loadStatus,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.integrationsTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.integrationsSubtitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          _buildConnectionCard(context),
          if (_syncResult != null) ...[
            const SizedBox(height: 20),
            _buildSyncResultCard(context),
          ],
          const SizedBox(height: 20),
          _buildActivitiesSection(context),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = _status;
    final connected = status?.connected ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'STRAVA',
              style: TextStyle(
                color: AppColors.accentDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.integrationsConnectionTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              children: [
                Text(
                  connected
                      ? l10n.integrationsConnected
                      : l10n.integrationsDisconnected,
                  style: TextStyle(
                    color: connected ? AppColors.success : AppColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (status?.athleteId != null)
                  Text('${l10n.integrationsAthleteId}: ${status!.athleteId}'),
              ],
            ),
            const SizedBox(height: 18),
            if (!connected)
              ElevatedButton(
                onPressed: _openStravaConnect,
                child: Text(l10n.integrationsConnectAction),
              )
            else
              ElevatedButton(
                onPressed: _syncInProgress ? null : _syncActivities,
                child: Text(
                  _syncInProgress
                      ? l10n.integrationsSyncing
                      : l10n.integrationsSyncAction,
                ),
              ),
            if (status?.lastSyncAt != null) ...[
              const SizedBox(height: 18),
              Text(
                '${l10n.integrationsLastSync}: ${_formatDateTime(status!.lastSyncAt)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: const TextStyle(color: AppColors.danger, fontSize: 15),
              ),
            ],
            if (!connected) ...[
              const SizedBox(height: 16),
              Text(
                l10n.integrationsRedirectHint,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSyncResultCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final result = _syncResult!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.integrationsResultTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              '${l10n.integrationsImportedActivities}: ${result.importedActivities}',
            ),
            const SizedBox(height: 6),
            Text(
              '${l10n.integrationsMatchedDays}: ${result.matchedTrainingDays}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AKTYWNOSCI',
              style: TextStyle(
                color: AppColors.accentDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.integrationsActivitiesTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<ActivityType?>(
              value: _selectedActivityType,
              decoration: InputDecoration(hintText: l10n.integrationsFilterAll),
              items: [
                DropdownMenuItem<ActivityType?>(
                  value: null,
                  child: Text(l10n.integrationsFilterAll),
                ),
                for (final type in ActivityType.values)
                  DropdownMenuItem<ActivityType?>(
                    value: type,
                    child: Text(activityTypeLabel(context, type)),
                  ),
              ],
              onChanged: (value) async {
                setState(() {
                  _selectedActivityType = value;
                });
                await _loadActivities();
              },
            ),
            const SizedBox(height: 18),
            if (_activitiesLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: LoadingView(),
                ),
              )
            else if (_activities.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  l10n.integrationsActivitiesEmpty,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _activities.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final activity = _activities[index];
                  return _ActivityCard(
                    activity: activity,
                    onTap: () =>
                        context.go('/integrations/activities/${activity.id}'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadStatus() async {
    try {
      final status = await ref.read(stravaRepositoryProvider).getStatus();

      if (!mounted) {
        return;
      }

      setState(() {
        _status = status;
        _errorMessage = '';
        _loading = false;
      });

      if (status.connected) {
        await _loadActivities();
      } else {
        setState(() {
          _activities = const [];
        });
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = const StravaConnectionStatus(
          connected: false,
          athleteId: null,
          lastSyncAt: null,
          authorizationUrl: '',
        );
        _activities = const [];
        _loading = false;
        _errorMessage = _readableMessage(error);
      });
    }
  }

  Future<void> _loadActivities() async {
    final status = _status;
    if (status == null || !status.connected) {
      return;
    }

    setState(() {
      _activitiesLoading = true;
    });

    try {
      final activities = await ref
          .read(stravaRepositoryProvider)
          .getActivities(activityType: _selectedActivityType);

      if (!mounted) {
        return;
      }

      setState(() {
        _activities = activities;
        _activitiesLoading = false;
        _errorMessage = '';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _activitiesLoading = false;
        _errorMessage = _readableMessage(error);
      });
    }
  }

  Future<void> _syncActivities() async {
    final athleteId = _status?.athleteId;
    if (athleteId == null) {
      return;
    }

    setState(() {
      _syncInProgress = true;
    });

    try {
      final result = await ref.read(stravaRepositoryProvider).sync(athleteId);

      if (!mounted) {
        return;
      }

      setState(() {
        _syncResult = result;
        _syncInProgress = false;
        _errorMessage = '';
      });

      await _loadStatus();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _syncInProgress = false;
        _errorMessage = _readableMessage(error);
      });
    }
  }

  Future<void> _openStravaConnect() async {
    final authorizationUrl = _status?.authorizationUrl;
    if (authorizationUrl == null || authorizationUrl.isEmpty) {
      return;
    }

    try {
      await ref
          .read(stravaRepositoryProvider)
          .openAuthorizationUrl(authorizationUrl);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = _readableMessage(error);
      });
    }
  }

  void _listenForDeepLinks() {
    _deepLinkSubscription = ref
        .read(stravaRepositoryProvider)
        .incomingLinks
        .listen((uri) {
          _handleStravaCallback(uri);
        });
  }

  Future<void> _handleInitialDeepLink() async {
    final uri = await ref.read(stravaRepositoryProvider).getInitialLink();
    if (uri == null) {
      return;
    }

    await _handleStravaCallback(uri);
  }

  Future<void> _handleStravaCallback(Uri uri) async {
    final l10n = AppLocalizations.of(context);
    final error = uri.queryParameters['error'];
    if (error != null && error.isNotEmpty) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = l10n.resolveError('errorStravaAuthorizationDenied');
      });
      return;
    }

    final code = uri.queryParameters['code'];
    if (code == null || code.isEmpty) {
      return;
    }

    try {
      await ref.read(stravaRepositoryProvider).exchangeToken(code);
      if (!mounted) {
        return;
      }

      await _loadStatus();
      if ((_status?.athleteId ?? 0) > 0) {
        await _syncActivities();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = _readableMessage(error);
      });
    }
  }

  String _readableMessage(Object error) {
    final l10n = AppLocalizations.of(context);
    if (error is ApiException) {
      return l10n.resolveError(error.code ?? error.message);
    }

    return error.toString().replaceFirst('Exception: ', '');
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '-';
    }

    final local = dateTime.toLocal();
    return '${local.day.toString().padLeft(2, '0')}.${local.month.toString().padLeft(2, '0')}.${local.year} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity, required this.onTap});

  final StravaActivity activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceStrong,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  activityTypeLabel(
                    context,
                    activity.activityType,
                  ).toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.accentDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(activity.activityDate),
                  style: const TextStyle(
                    color: AppColors.accentDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              activity.name,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${formatDistanceKm(activity.distanceMeters)} / ${formatDurationShort(activity.movingTimeSeconds)}',
              style: const TextStyle(color: AppColors.text, fontSize: 16),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: activity.matchedToPlan
                    ? const Color(0xFFE6F0DE)
                    : const Color(0xFFF1E9E1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: activity.matchedToPlan
                          ? const Color(0xFFD2E2C7)
                          : const Color(0xFFE5DDD5),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      activity.matchedToPlan
                          ? l10n.integrationsMatched
                          : l10n.integrationsUnmatched,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    activity.matchedToPlan
                        ? (activity.matchedTrainingDayTitle ?? '')
                        : l10n.integrationsUnmatchedDescription,
                    style: const TextStyle(color: AppColors.text, fontSize: 15),
                  ),
                  if (activity.matchedToPlan &&
                      (activity.matchedPlanName?.isNotEmpty ?? false)) ...[
                    const SizedBox(height: 6),
                    Text(
                      activity.matchedPlanName!,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
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
}
