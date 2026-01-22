import 'package:flutter/material.dart';

class AppSettings extends InheritedWidget {
  final bool isDarkMode;
  final String weightUnit;
  final VoidCallback toggleDarkMode;
  final Function(String) setWeightUnit;

  const AppSettings({
    super.key,
    required this.isDarkMode,
    required this.weightUnit,
    required this.toggleDarkMode,
    required this.setWeightUnit,
    required super.child,
  });

  static AppSettings of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppSettings>();
    assert(result != null, 'AppSettings não encontrado na árvore de widgets');
    return result!;
  }

  @override
  bool updateShouldNotify(AppSettings oldWidget) {
    return isDarkMode != oldWidget.isDarkMode ||
        weightUnit != oldWidget.weightUnit;
  }
}
