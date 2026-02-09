import 'package:fittracker/modules/exercise/exercise_api_service.dart';
import 'package:fittracker_core/fittracker_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Pagina de lista de exercicios (modulo Exercise).
///
/// Utiliza [Modular.get] para obter o [ExerciseApiService]
/// e [Modular.to] para navegar ao detalhe do exercicio.
class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({super.key});

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  final ExerciseApiService service = Modular.get<ExerciseApiService>();
  late Future<List<Exercise>> _exercisesFuture;
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _exercisesFuture = service.getAll();
    _statsFuture = service.getStats();
  }

  void _refresh() {
    setState(() {
      _loadData();
    });
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
      body: Column(
        children: [
          // Card de estatisticas
          FutureBuilder<Map<String, dynamic>>(
            future: _statsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Erro ao carregar estatisticas',
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  ),
                );
              }
              final stats = snapshot.data!;
              return Card(
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
              );
            },
          ),

          // Lista de exercicios
          Expanded(
            child: FutureBuilder<List<Exercise>>(
              future: _exercisesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text('Erro ao conectar com a API'),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _refresh,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }

                final exercises = snapshot.data!;
                if (exercises.isEmpty) {
                  return const Center(
                    child: Text('Nenhum exercicio cadastrado'),
                  );
                }

                return ListView.builder(
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
                          onChanged: (value) async {
                            await service.toggleComplete(exercise.id);
                            _refresh();
                          },
                        ),
                        title: Text(
                          exercise.name,
                          style: TextStyle(
                            decoration: exercise.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: exercise.isCompleted ? Colors.grey : null,
                          ),
                        ),
                        subtitle: Text(
                          '${exercise.sets} series x ${exercise.reps} reps - '
                          '${exercise.category}'
                          '${exercise.weight != null ? ' @ ${exercise.weight}kg' : ''}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Modular.to.pushNamed('/exercises/${exercise.id}');
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
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
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await service.add(
                  Exercise(
                    name: nameController.text,
                    sets: int.tryParse(setsController.text) ?? 3,
                    reps: int.tryParse(repsController.text) ?? 12,
                    category: selectedCategory,
                  ),
                );
                if (context.mounted) Navigator.pop(context);
                _refresh();
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
