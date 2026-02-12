import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/entities/exercise.dart';
import '../controllers/exercise_controller.dart';

/// Pagina de lista de exercicios.
class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({super.key});

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  late final ExerciseController controller;

  @override
  void initState() {
    super.initState();
    controller = Modular.get<ExerciseController>();
    controller.loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercicios'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          final stats = controller.stats;
          final exercises = controller.exercises;

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Total',
                        '${stats['total']}',
                        Icons.fitness_center,
                      ),
                      _buildStatItem(
                        'Completos',
                        '${stats['completed']}',
                        Icons.check_circle,
                      ),
                      _buildStatItem(
                        'Series',
                        '${stats['totalSets']}',
                        Icons.repeat,
                      ),
                      _buildStatItem(
                        'Categorias',
                        '${stats['categories']}',
                        Icons.category,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: exercises.isEmpty
                    ? const Center(child: Text('Nenhum exercicio cadastrado'))
                    : ListView.builder(
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: exercise.isCompleted,
                                onChanged: (_) => controller
                                    .toggleExerciseComplete(exercise.id),
                              ),
                              title: Text(
                                exercise.name,
                                style: TextStyle(
                                  decoration: exercise.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: exercise.isCompleted
                                      ? Colors.grey
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                '${exercise.sets} series x ${exercise.reps} reps - '
                                '${exercise.category}'
                                '${exercise.weight != null ? ' @ ${exercise.weight}kg' : ''}',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Modular.to.pushNamed(
                                  '/exercises/${exercise.id}',
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _refresh() {
    controller.loadExercises();
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final setsController = TextEditingController(text: '3');
    final repsController = TextEditingController(text: '12');
    String selectedCategory = 'Peito';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Exercicio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: setsController,
                    decoration: const InputDecoration(labelText: 'Series'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: repsController,
                    decoration: const InputDecoration(labelText: 'Reps'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: [
                'Peito',
                'Pernas',
                'Costas',
                'Ombros',
                'Bracos',
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (value) {
                selectedCategory = value ?? 'Peito';
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final exercise = Exercise(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  sets: int.tryParse(setsController.text) ?? 3,
                  reps: int.tryParse(repsController.text) ?? 12,
                  category: selectedCategory,
                );
                controller.addNewExercise(exercise);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
