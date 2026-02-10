import 'package:fittracker/service/exercice_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Pagina inicial do FitTracker (modulo Home).
///
/// Utiliza [Modular.get] para obter o [ExerciseApiService]
/// e [Modular.to] para navegacao entre modulos.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final exerciseApiService = Modular.get<ExerciseApiService>();

    return Scaffold(
      appBar: AppBar(title: const Text('FitTracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Icone
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

            // Contadores via FutureBuilder
            FutureBuilder<Map<String, dynamic>>(
              future: exerciseApiService.getStats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Erro ao carregar dados',
                    style: TextStyle(fontSize: 14, color: Colors.red[400]),
                  );
                }
                final stats = snapshot.data!;
                return Text(
                  '${stats['total']} exercicios | '
                  '${stats['completed']} completos',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                );
              },
            ),
            const SizedBox(height: 48),

            // Botao Exercicios
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

            // Botao Timer
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

            // Botao Estatisticas
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
