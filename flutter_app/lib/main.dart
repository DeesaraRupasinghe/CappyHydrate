import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/app_state.dart';
import 'services/notification_service.dart';
import 'services/preferences_service.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/reminder_screen.dart';

/// Global navigator key — used so the notification callback can push routes
/// without requiring a BuildContext.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise services
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermission();

  final prefsService = await PreferencesService.create();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(
        prefs: prefsService,
        notifications: notificationService,
      ),
      child: const CappyHydrateApp(),
    ),
  );
}

/// Root application widget.
class CappyHydrateApp extends StatelessWidget {
  const CappyHydrateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CappyHydrate',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      // Use a warm, earthy colour scheme matching the capybara theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA8DADC),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/reminder': (_) => const ReminderScreen(),
      },
    );
  }
}
