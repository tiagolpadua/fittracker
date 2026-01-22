// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fittracker/app.dart';

void main() {
  testWidgets('FitTracker app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(FitTrackerApp());

    // Verify that the app title is displayed
    expect(find.text('FitTracker'), findsOneWidget);

    // Verify that the workout counter shows 0
    expect(find.text('0'), findsOneWidget);

    // Verify that the exercises are displayed
    expect(find.text('Supino Reto'), findsOneWidget);
    expect(find.text('Agachamento'), findsOneWidget);
  });

  testWidgets('Can navigate to settings', (WidgetTester tester) async {
    await tester.pumpWidget(FitTrackerApp());

    // Tap the settings icon
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Verify settings screen is displayed
    expect(find.text('Configurações'), findsOneWidget);
    expect(find.text('Modo Escuro'), findsOneWidget);
  });
}
