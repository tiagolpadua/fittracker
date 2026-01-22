import 'package:fittracker/screens/home_screen.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/timer': (context) => TimerScreen(),
      },
    );
  }
}
