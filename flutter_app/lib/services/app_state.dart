import 'package:flutter/material.dart';
import '../models/water_settings.dart';
import '../services/preferences_service.dart';
import '../services/notification_service.dart';

/// App-wide state — water count, settings, next reminder time.
class AppState extends ChangeNotifier {
  WaterSettings _settings = WaterSettings.defaults();
  int _waterCount = 0;
  String _nextReminder = '';

  final PreferencesService _prefs;
  final NotificationService _notifications;

  AppState({
    required PreferencesService prefs,
    required NotificationService notifications,
  })  : _prefs = prefs,
        _notifications = notifications {
    _load();
  }

  // ── Getters ──────────────────────────────────────────────────────────────────

  WaterSettings get settings => _settings;
  int get waterCount => _waterCount;
  String get nextReminder => _nextReminder;
  bool get goalReached => _waterCount >= _settings.totalBottles;

  // ── Actions ──────────────────────────────────────────────────────────────────

  /// Increment the water count when the user taps "I Drank Water!".
  Future<void> drinkWater() async {
    if (goalReached) return;
    _waterCount = await _prefs.incrementWaterCount();
    _updateNextReminder();
    notifyListeners();
  }

  /// Save new [settings] and reschedule notifications.
  Future<void> updateSettings(WaterSettings settings) async {
    _settings = settings;
    await _prefs.saveSettings(settings);
    await _notifications.scheduleReminders(settings);
    _updateNextReminder();
    notifyListeners();
  }

  // ── Internal ─────────────────────────────────────────────────────────────────

  void _load() {
    _settings = _prefs.loadSettings();
    _waterCount = _prefs.getTodayCount();
    _updateNextReminder();
  }

  void _updateNextReminder() {
    // If the user has already reached their goal, show a completed message
    if (goalReached) {
      _nextReminder = 'Goal complete for today! 🎉';
      return;
    }

    final interval = _settings.reminderIntervalMinutes;
    final wakeUpParts = WaterSettings.parseTime(_settings.sleepEnd);
    final now = DateTime.now();
    final wakeUp = DateTime(
        now.year, now.month, now.day, wakeUpParts[0], wakeUpParts[1]);

    final nextIndex = _waterCount + 1;
    final nextTime = wakeUp.add(Duration(minutes: interval * nextIndex));

    if (nextTime.isAfter(now)) {
      final diff = nextTime.difference(now);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      if (hours > 0) {
        _nextReminder = 'in ${hours}h ${minutes}m';
      } else {
        _nextReminder = 'in ${minutes} min';
      }
    } else {
      _nextReminder = 'soon';
    }
  }
}
