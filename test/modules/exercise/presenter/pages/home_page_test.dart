import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage deve exibir titulo FitTracker', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('FitTracker')),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center, size: 80, color: Colors.orange),
                SizedBox(height: 16),
                Text('FitTracker', style: TextStyle(fontSize: 36)),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('FitTracker'), findsWidgets);
    expect(find.byIcon(Icons.fitness_center), findsOneWidget);
  });

  testWidgets('deve encontrar botoes de navegacao', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Exercicios'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Timer de Descanso'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Exercicios'), findsOneWidget);
    expect(find.text('Timer de Descanso'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('deve responder ao tap', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () => tapped = true,
            child: const Text('Clique'),
          ),
        ),
      ),
    );

    expect(tapped, isFalse);
    await tester.tap(find.text('Clique'));
    expect(tapped, isTrue);
  });
}
