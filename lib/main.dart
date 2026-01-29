import 'package:fittracker/config/app_theme.dart';
import 'package:fittracker/config/settings_provider.dart';
import 'package:fittracker/constants/app_constants.dart';
import 'package:fittracker/screens/home_screen.dart';
import 'package:fittracker/screens/new_exercise_screen.dart';
import 'package:fittracker/screens/timer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const FitTrackerApp(),
    ),
  );
}

class FitTrackerApp extends StatelessWidget {
  const FitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'FitTracker',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode,
          initialRoute: AppConstants.routeHome,
          routes: {
            AppConstants.routeHome: (context) => const HomeScreen(),
            AppConstants.routeNewExercise: (context) =>
                const NewExerciseScreen(),
            AppConstants.routeTimer: (context) => const TimerScreen(),
          },
        );
      },
    );
  }
}
