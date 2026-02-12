import 'package:flutter/material.dart';

/// Configuracao de tema da aplicacao FitTracker.
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.orange,
    brightness: Brightness.light,
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.orange,
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}
