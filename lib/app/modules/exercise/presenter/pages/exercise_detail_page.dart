import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/exercise.dart';
import '../controllers/exercise_controller.dart';

/// Pagina de detalhes de um exercicio.
class ExerciseDetailPage extends StatelessWidget {
  final String id;

  const ExerciseDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<ExerciseController>();

    return FutureBuilder<Exercise?>(
      future: controller.loadById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Carregando...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Erro')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erro ao carregar exercicio: ${snapshot.error}'),
                ],
              ),
            ),
          );
        }

        final exercise = snapshot.data;

        if (exercise == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Exercicio nao encontrado')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Exercicio com ID "$id" nao encontrado'),
                ],
              ),
            ),
          );
        }

        return _buildDetailScaffold(exercise);
      },
    );
  }

  Widget _buildDetailScaffold(Exercise exercise) {
    return Scaffold(
      appBar: AppBar(title: Text(exercise.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(exercise.category),
                      backgroundColor: Colors.orange[100],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.repeat, color: Colors.orange),
                    title: const Text('Series'),
                    trailing: Text(
                      '${exercise.sets}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.fitness_center,
                      color: Colors.orange,
                    ),
                    title: const Text('Repeticoes'),
                    trailing: Text(
                      '${exercise.reps}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (exercise.weight != null) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.monitor_weight,
                        color: Colors.orange,
                      ),
                      title: const Text('Peso'),
                      trailing: Text(
                        '${exercise.weight}kg',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.category, color: Colors.orange),
                    title: const Text('Categoria'),
                    trailing: Text(
                      exercise.category,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      exercise.isCompleted
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: exercise.isCompleted ? Colors.green : Colors.grey,
                    ),
                    title: const Text('Status'),
                    trailing: Text(
                      exercise.isCompleted ? 'Completo' : 'Pendente',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: exercise.isCompleted
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.analytics, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Volume total: ${exercise.sets * exercise.reps} reps',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    if (exercise.weight != null) ...[
                      Text(
                        ' | ${(exercise.sets * exercise.reps * exercise.weight!).toStringAsFixed(0)}kg',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
