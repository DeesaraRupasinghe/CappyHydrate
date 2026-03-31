/// Water settings model — stores user preferences for reminders.
class WaterSettings {
  final int totalBottles;
  final String sleepStart; // "HH:mm" format
  final String sleepEnd;   // "HH:mm" format

  const WaterSettings({
    required this.totalBottles,
    required this.sleepStart,
    required this.sleepEnd,
  });

  /// Default settings (4 bottles, sleep 22:00–07:00).
  factory WaterSettings.defaults() => const WaterSettings(
        totalBottles: 4,
        sleepStart: '22:00',
        sleepEnd: '07:00',
      );

  WaterSettings copyWith({
    int? totalBottles,
    String? sleepStart,
    String? sleepEnd,
  }) {
    return WaterSettings(
      totalBottles: totalBottles ?? this.totalBottles,
      sleepStart: sleepStart ?? this.sleepStart,
      sleepEnd: sleepEnd ?? this.sleepEnd,
    );
  }

  /// Parse "HH:mm" string into hours and minutes.
  static List<int> parseTime(String time) {
    final parts = time.split(':');
    return [int.parse(parts[0]), int.parse(parts[1])];
  }

  /// Calculate awake duration in minutes (sleep end → sleep start).
  int get awakeDurationMinutes {
    final start = parseTime(sleepEnd);  // wake-up time
    final end = parseTime(sleepStart);  // bedtime
    int startMins = start[0] * 60 + start[1];
    int endMins = end[0] * 60 + end[1];
    if (endMins <= startMins) {
      endMins += 24 * 60; // handle midnight crossing
    }
    return endMins - startMins;
  }

  /// Calculate reminder interval in minutes.
  int get reminderIntervalMinutes {
    if (totalBottles <= 1) return awakeDurationMinutes;
    return awakeDurationMinutes ~/ totalBottles;
  }
}
