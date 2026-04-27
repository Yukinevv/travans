enum TrainingDayStatus {
  planned('PLANNED'),
  completed('COMPLETED'),
  partiallyCompleted('PARTIALLY_COMPLETED'),
  missed('MISSED');

  const TrainingDayStatus(this.apiValue);

  final String apiValue;

  static TrainingDayStatus fromApi(String? value) {
    return TrainingDayStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => TrainingDayStatus.planned,
    );
  }
}
