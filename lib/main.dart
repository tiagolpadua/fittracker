import 'package:fittracker/config/app_theme.dart';
import 'package:fittracker/constants/app_constants.dart';
import 'package:fittracker/screens/home_screen.dart';
import 'package:fittracker/screens/new_exercise_screen.dart';
import 'package:fittracker/screens/timer_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FitTrackerApp());
}

class FitTrackerApp extends StatelessWidget {
  const FitTrackerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppConstants.routeHome,
      routes: {
        AppConstants.routeHome: (context) => const HomeScreen(),
        AppConstants.routeNewExercise: (context) => const NewExerciseScreen(),
        AppConstants.routeTimer: (context) => const TimerScreen(),
      },
    );
  }
}
