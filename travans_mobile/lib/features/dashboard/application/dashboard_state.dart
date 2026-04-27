import '../../plans/data/plan_models.dart';
import '../data/dashboard_models.dart';

class DashboardState {
  const DashboardState({
    required this.loading,
    required this.loadingPlans,
    required this.plans,
    required this.selectedPlanId,
    required this.summary,
    required this.errorMessage,
  });

  final bool loading;
  final bool loadingPlans;
  final List<TrainingPlan> plans;
  final int? selectedPlanId;
  final DashboardSummary? summary;
  final String errorMessage;

  DashboardState copyWith({
    bool? loading,
    bool? loadingPlans,
    List<TrainingPlan>? plans,
    int? selectedPlanId,
    bool clearSelectedPlanId = false,
    DashboardSummary? summary,
    bool clearSummary = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      loadingPlans: loadingPlans ?? this.loadingPlans,
      plans: plans ?? this.plans,
      selectedPlanId: clearSelectedPlanId
          ? null
          : selectedPlanId ?? this.selectedPlanId,
      summary: clearSummary ? null : summary ?? this.summary,
      errorMessage: clearError ? '' : errorMessage ?? this.errorMessage,
    );
  }

  static const initial = DashboardState(
    loading: true,
    loadingPlans: true,
    plans: [],
    selectedPlanId: null,
    summary: null,
    errorMessage: '',
  );
}
