import '../../infra/datasources/exercise_datasource.dart';
import '../../infra/models/exercise_model.dart';

/// Implementacao in-memory do DataSource.
class ExerciseDataSourceInMemory implements ExerciseDataSource {
  final List<ExerciseModel> _exercises = [
    const ExerciseModel(
      id: '1',
      name: 'Supino Reto Em Memória',
      sets: 4,
      reps: 12,
      category: 'Peito',
      weight: 60.0,
    ),
    const ExerciseModel(
      id: '2',
      name: 'Agachamento',
      sets: 4,
      reps: 10,
      category: 'Pernas',
      weight: 80.0,
    ),
  ];

  @override
  Future<List<ExerciseModel>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_exercises);
  }

  @override
  Future<ExerciseModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _exercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(ExerciseModel exercise) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _exercises.indexWhere((e) => e.id == exercise.id);
    if (index != -1) {
      _exercises[index] = exercise;
    } else {
      _exercises.add(exercise);
    }
  }

  @override
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _exercises.removeWhere((e) => e.id == id);
  }
}
