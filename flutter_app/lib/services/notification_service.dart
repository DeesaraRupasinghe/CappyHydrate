import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/water_settings.dart';

/// Manages local notification scheduling for water reminders.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize the notification plugin.  Call once at app startup.
  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    _initialized = true;
  }

  // ── Permission ───────────────────────────────────────────────────────────────

  /// Request notification permission (Android 13+).
  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return false;
    final granted = await android.requestNotificationsPermission();
    return granted ?? false;
  }

  // ── Scheduling ───────────────────────────────────────────────────────────────

  /// Cancel all existing reminders and schedule new ones based on [settings].
  Future<void> scheduleReminders(WaterSettings settings) async {
    await cancelAllReminders();

    final now = DateTime.now();
    final wakeUpParts = WaterSettings.parseTime(settings.sleepEnd);
    final wakeUp = DateTime(
      now.year,
      now.month,
      now.day,
      wakeUpParts[0],
      wakeUpParts[1],
    );

    final intervalMinutes = settings.reminderIntervalMinutes;

    for (int i = 0; i < settings.totalBottles; i++) {
      final reminderTime =
          wakeUp.add(Duration(minutes: intervalMinutes * (i + 1)));

      // Only schedule future reminders
      if (reminderTime.isAfter(now)) {
        await _scheduleNotification(
          id: i,
          title: 'Cappy says hi! 🐾',
          body: 'Your capybara reminds you to drink water 🐾💧',
          scheduledTime: reminderTime,
        );
      }
    }
  }

  /// Cancel all scheduled reminders.
  Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
  }

  // ── Internal ─────────────────────────────────────────────────────────────────

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'water_reminders',
      'Water Reminders',
      channelDescription: 'Reminds you to drink water throughout the day',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  void _onNotificationResponse(NotificationResponse response) {
    // Navigation to the reminder screen is handled in main.dart via
    // onDidReceiveNotificationResponse callback using a global navigator key.
  }
}
