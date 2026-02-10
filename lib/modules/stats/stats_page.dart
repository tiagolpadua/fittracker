import 'package:fittracker/modules/exercise/exercise_api_service.dart';
import 'package:fittracker_core/fittracker_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Pagina de estatisticas do treino.
///
/// Utiliza [Modular.get] para acessar o [ExerciseApiService]
/// compartilhado registrado no [AppModule].
/// Dados carregados assincronamente da API REST.
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Modular.get<ExerciseApiService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Estatisticas')),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([service.getStats(), service.getAll()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Erro ao carregar estatisticas'),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final stats = snapshot.data![0] as Map<String, dynamic>;
          final exercises = snapshot.data![1] as List<Exercise>;
          final categories = exercises.map((e) => e.category).toSet().toList()
            ..sort();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Card de resumo geral
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumo do Treino',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow('Total de Exercicios', '${stats['total']}'),
                      _buildStatRow(
                        'Exercicios Completos',
                        '${stats['completed']}',
                      ),
                      _buildStatRow('Total de Series', '${stats['totalSets']}'),
                      _buildStatRow(
                        'Total de Repeticoes',
                        '${stats['totalReps']}',
                      ),
                      _buildStatRow('Categorias', '${stats['categories']}'),
                      const SizedBox(height: 8),
                      if ((stats['total'] as int) > 0)
                        LinearProgressIndicator(
                          value:
                              (stats['completed'] as int) /
                              (stats['total'] as int),
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation(
                            Colors.orange,
                          ),
                          minHeight: 8,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Cards por categoria
              Text(
                'Por Categoria',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              ...categories.map((category) {
                final catExercises = exercises
                    .where((e) => e.category == category)
                    .toList();
                final completed = catExercises
                    .where((e) => e.isCompleted)
                    .length;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Text(
                        category[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(category),
                    subtitle: Text(
                      '$completed/${catExercises.length} completos',
                    ),
                    trailing: SizedBox(
                      width: 60,
                      child: LinearProgressIndicator(
                        value: catExercises.isEmpty
                            ? 0
                            : completed / catExercises.length,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation(Colors.orange),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
