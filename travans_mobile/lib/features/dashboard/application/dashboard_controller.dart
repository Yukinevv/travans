import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/networking/api_exception.dart';
import '../../../core/storage/preferences_service.dart';
import '../../plans/data/plans_repository.dart';
import '../data/dashboard_repository.dart';
import 'dashboard_state.dart';

final dashboardControllerProvider =
    StateNotifierProvider.autoDispose<DashboardController, DashboardState>((
      ref,
    ) {
      final controller = DashboardController(
        dashboardRepository: ref.watch(dashboardRepositoryProvider),
        plansRepository: ref.watch(plansRepositoryProvider),
        preferencesService: ref.watch(preferencesServiceProvider),
      );
      controller.initialize();
      return controller;
    });

class DashboardController extends StateNotifier<DashboardState> {
  DashboardController({
    required DashboardRepository dashboardRepository,
    required PlansRepository plansRepository,
    required PreferencesService preferencesService,
  }) : _dashboardRepository = dashboardRepository,
       _plansRepository = plansRepository,
       _preferencesService = preferencesService,
       super(DashboardState.initial);

  final DashboardRepository _dashboardRepository;
  final PlansRepository _plansRepository;
  final PreferencesService _preferencesService;

  Future<void> initialize() async {
    try {
      final plans = await _plansRepository.getPlans();
      final storedPlanId = await _preferencesService.readSelectedPlanId();
      final hasStoredPlan = storedPlanId != null &&
          plans.any((plan) => plan.id == storedPlanId);
      final selectedPlanId = hasStoredPlan ? storedPlanId : null;

      state = state.copyWith(
        plans: plans,
        selectedPlanId: selectedPlanId,
        loadingPlans: false,
        clearError: true,
      );

      if (storedPlanId != selectedPlanId) {
        await _preferencesService.saveSelectedPlanId(selectedPlanId);
      }

      await _loadSummary(selectedPlanId);
    } on ApiException catch (error) {
      state = state.copyWith(
        loading: false,
        loadingPlans: false,
        errorMessage: error.message,
      );
    } catch (_) {
      state = state.copyWith(
        loading: false,
        loadingPlans: false,
        errorMessage: 'Nie udalo sie pobrac listy planow.',
      );
    }
  }

  Future<void> selectPlan(int? planId) async {
    state = state.copyWith(selectedPlanId: planId, clearError: true);
    await _preferencesService.saveSelectedPlanId(planId);
    await _loadSummary(planId);
  }

  Future<void> reload() async {
    state = state.copyWith(loading: true, clearError: true);
    await initialize();
  }

  Future<void> _loadSummary(int? planId) async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final summary = await _dashboardRepository.getSummary(planId: planId);
      final nextSelectedPlanId = summary.currentPlanId;

      if (nextSelectedPlanId != state.selectedPlanId) {
        await _preferencesService.saveSelectedPlanId(nextSelectedPlanId);
      }

      state = state.copyWith(
        summary: summary,
        selectedPlanId: nextSelectedPlanId,
        loading: false,
        clearError: true,
      );
    } on ApiException catch (error) {
      state = state.copyWith(loading: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        loading: false,
        errorMessage: 'Nie udalo sie pobrac danych dashboardu.',
      );
    }
  }
}
