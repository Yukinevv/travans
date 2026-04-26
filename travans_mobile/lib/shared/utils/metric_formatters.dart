String formatDistanceKm(int? distanceMeters) {
  if (distanceMeters == null || distanceMeters <= 0) {
    return '-';
  }

  return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
}

String formatDurationShort(int? seconds) {
  if (seconds == null || seconds <= 0) {
    return '-';
  }

  final totalMinutes = (seconds / 60).round();
  if (totalMinutes >= 60) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return minutes > 0 ? '$hours h $minutes min' : '$hours h';
  }

  return '$totalMinutes min';
}

String formatSpeedKph(double? speedMetersPerSecond) {
  if (speedMetersPerSecond == null || speedMetersPerSecond <= 0) {
    return '-';
  }

  return '${(speedMetersPerSecond * 3.6).toStringAsFixed(1)} km/h';
}

String formatPace(double? speedMetersPerSecond) {
  if (speedMetersPerSecond == null || speedMetersPerSecond <= 0) {
    return '-';
  }

  final secondsPerKm = 1000 / speedMetersPerSecond;
  final minutes = secondsPerKm ~/ 60;
  final seconds = (secondsPerKm % 60).round();
  return '$minutes:${seconds.toString().padLeft(2, '0')} min/km';
}
