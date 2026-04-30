import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/networking/api_exception.dart';
import '../../../core/storage/preferences_service.dart';
import '../data/plans_repository.dart';
import 'plans_state.dart';

final plansControllerProvider =
    StateNotifierProvider.autoDispose<PlansController, PlansState>((ref) {
      final controller = PlansController(
        plansRepository: ref.watch(plansRepositoryProvider),
        preferencesService: ref.watch(preferencesServiceProvider),
      );
      controller.initialize();
      return controller;
    });

class PlansController extends StateNotifier<PlansState> {
  PlansController({
    required PlansRepository plansRepository,
    required PreferencesService preferencesService,
  }) : _plansRepository = plansRepository,
       _preferencesService = preferencesService,
       super(PlansState.initial);

  final PlansRepository _plansRepository;
  final PreferencesService _preferencesService;

  Future<void> initialize() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final plans = await _plansRepository.getPlans();
      final storedPlanId = await _preferencesService.readSelectedPlanId();
      final selectedPlanId = plans.any((plan) => plan.id == storedPlanId)
          ? storedPlanId
          : null;

      if (storedPlanId != selectedPlanId) {
        await _preferencesService.saveSelectedPlanId(selectedPlanId);
      }

      state = state.copyWith(
        loading: false,
        plans: plans,
        selectedDashboardPlanId: selectedPlanId,
        clearError: true,
      );
    } on ApiException catch (error) {
      state = state.copyWith(loading: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        loading: false,
        errorMessage: 'Nie udało się pobrać listy planów.',
      );
    }
  }

  Future<void> reload() async {
    await initialize();
  }

  Future<void> pinToDashboard(int? planId) async {
    await _preferencesService.saveSelectedPlanId(planId);
    state = state.copyWith(selectedDashboardPlanId: planId, clearError: true);
  }

  Future<String?> deletePlan(int planId) async {
    state = state.copyWith(deletingPlanId: planId, clearError: true);

    try {
      await _plansRepository.deletePlan(planId);
      final nextPlans = state.plans.where((plan) => plan.id != planId).toList();
      final wasPinned = state.selectedDashboardPlanId == planId;

      if (wasPinned) {
        await _preferencesService.saveSelectedPlanId(null);
      }

      state = state.copyWith(
        plans: nextPlans,
        selectedDashboardPlanId: wasPinned
            ? null
            : state.selectedDashboardPlanId,
        clearDeletingPlanId: true,
        clearError: true,
      );
      return null;
    } on ApiException catch (error) {
      state = state.copyWith(
        clearDeletingPlanId: true,
        errorMessage: error.message,
      );
      return error.message;
    } catch (_) {
      const message = 'Nie udało się usunąć planu.';
      state = state.copyWith(
        clearDeletingPlanId: true,
        errorMessage: message,
      );
      return message;
    }
  }
}
