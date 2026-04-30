import '../data/plan_models.dart';

class PlansState {
  const PlansState({
    required this.loading,
    required this.plans,
    required this.selectedDashboardPlanId,
    required this.deletingPlanId,
    required this.errorMessage,
  });

  final bool loading;
  final List<TrainingPlan> plans;
  final int? selectedDashboardPlanId;
  final int? deletingPlanId;
  final String errorMessage;

  PlansState copyWith({
    bool? loading,
    List<TrainingPlan>? plans,
    int? selectedDashboardPlanId,
    bool clearSelectedDashboardPlanId = false,
    int? deletingPlanId,
    bool clearDeletingPlanId = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PlansState(
      loading: loading ?? this.loading,
      plans: plans ?? this.plans,
      selectedDashboardPlanId: clearSelectedDashboardPlanId
          ? null
          : selectedDashboardPlanId ?? this.selectedDashboardPlanId,
      deletingPlanId: clearDeletingPlanId
          ? null
          : deletingPlanId ?? this.deletingPlanId,
      errorMessage: clearError ? '' : errorMessage ?? this.errorMessage,
    );
  }

  static const initial = PlansState(
    loading: true,
    plans: [],
    selectedDashboardPlanId: null,
    deletingPlanId: null,
    errorMessage: '',
  );
}
