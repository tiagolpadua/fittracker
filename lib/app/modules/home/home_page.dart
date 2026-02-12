import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Pagina inicial do FitTracker (modulo Home).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FitTracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 80, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'FitTracker',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Acompanhe seus exercicios com Clean Architecture',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 240,
              child: ElevatedButton.icon(
                onPressed: () {
                  Modular.to.pushNamed('/exercises');
                },
                icon: const Icon(Icons.fitness_center),
                label: const Text('Exercicios'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 240,
              child: ElevatedButton.icon(
                onPressed: () {
                  Modular.to.pushNamed('/timer');
                },
                icon: const Icon(Icons.timer),
                label: const Text('Timer de Descanso'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 240,
              child: OutlinedButton.icon(
                onPressed: () {
                  Modular.to.pushNamed('/stats');
                },
                icon: const Icon(Icons.bar_chart),
                label: const Text('Estatisticas'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
