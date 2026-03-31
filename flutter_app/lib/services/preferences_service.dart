import 'package:shared_preferences/shared_preferences.dart';
import '../models/water_settings.dart';

/// Handles reading and writing app settings to SharedPreferences.
class PreferencesService {
  static const _keyTotalBottles = 'total_bottles';
  static const _keySleepStart = 'sleep_start';
  static const _keySleepEnd = 'sleep_end';
  static const _keyWaterCount = 'water_count';
  static const _keyLastResetDate = 'last_reset_date';

  final SharedPreferences _prefs;

  PreferencesService._(this._prefs);

  /// Create a [PreferencesService] instance (async init required).
  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService._(prefs);
  }

  // ── Settings ────────────────────────────────────────────────────────────────

  /// Load saved [WaterSettings] (falls back to defaults when not yet set).
  WaterSettings loadSettings() {
    return WaterSettings(
      totalBottles: _prefs.getInt(_keyTotalBottles) ?? 4,
      sleepStart: _prefs.getString(_keySleepStart) ?? '22:00',
      sleepEnd: _prefs.getString(_keySleepEnd) ?? '07:00',
    );
  }

  /// Persist [WaterSettings] to disk.
  Future<void> saveSettings(WaterSettings settings) async {
    await _prefs.setInt(_keyTotalBottles, settings.totalBottles);
    await _prefs.setString(_keySleepStart, settings.sleepStart);
    await _prefs.setString(_keySleepEnd, settings.sleepEnd);
  }

  // ── Daily progress ───────────────────────────────────────────────────────────

  /// Returns how many bottles the user has drunk today, resetting if day changed.
  int getTodayCount() {
    _resetIfNewDay();
    return _prefs.getInt(_keyWaterCount) ?? 0;
  }

  /// Increment today's water count by 1.
  Future<int> incrementWaterCount() async {
    _resetIfNewDay();
    final current = _prefs.getInt(_keyWaterCount) ?? 0;
    final updated = current + 1;
    await _prefs.setInt(_keyWaterCount, updated);
    return updated;
  }

  /// Reset today's count to 0.
  Future<void> resetWaterCount() async {
    await _prefs.setInt(_keyWaterCount, 0);
  }

  // ── Internal helpers ─────────────────────────────────────────────────────────

  void _resetIfNewDay() {
    final today = _todayString();
    final lastReset = _prefs.getString(_keyLastResetDate) ?? '';
    if (lastReset != today) {
      _prefs.setInt(_keyWaterCount, 0);
      _prefs.setString(_keyLastResetDate, today);
    }
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
