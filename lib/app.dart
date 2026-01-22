import 'package:flutter/material.dart';

import 'core/settings/app_settings.dart';
import 'screens/exercise/new_exercise_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/timer/timer_screen.dart';

class FitTrackerApp extends StatefulWidget {
  const FitTrackerApp({super.key});

  @override
  State<FitTrackerApp> createState() => _FitTrackerAppState();
}

class _FitTrackerAppState extends State<FitTrackerApp> {
  bool _isDarkMode = false;
  String _weightUnit = 'kg';

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _setWeightUnit(String unit) {
    setState(() {
      _weightUnit = unit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppSettings(
      isDarkMode: _isDarkMode,
      weightUnit: _weightUnit,
      toggleDarkMode: _toggleDarkMode,
      setWeightUnit: _setWeightUnit,
      child: MaterialApp(
        title: 'FitTracker',
        debugShowCheckedModeBanner: false,
        theme: _isDarkMode
            ? ThemeData.dark()
            : ThemeData(
                primarySwatch: Colors.orange,
                brightness: Brightness.light,
              ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/exercise/new': (context) => NewExerciseScreen(),
          '/settings': (context) => SettingsScreen(),
          '/timer': (context) => TimerScreen(),
        },
      ),
    );
  }
}
