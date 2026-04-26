enum ActivityType {
  run('RUN'),
  ride('RIDE'),
  swim('SWIM'),
  walk('WALK'),
  workout('WORKOUT'),
  strength('STRENGTH'),
  other('OTHER');

  const ActivityType(this.apiValue);

  final String apiValue;

  static ActivityType fromApi(String? value) {
    return ActivityType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => ActivityType.other,
    );
  }
}
