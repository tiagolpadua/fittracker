import '../entities/exercise.dart';

/// Contrato abstrato para acesso a dados de exercicios.
abstract class ExerciseRepository {
  Future<List<Exercise>> getAll();
  Future<Exercise?> getById(String id);
  Future<void> add(Exercise exercise);
  Future<void> update(Exercise exercise);
  Future<void> remove(String id);
  Future<List<Exercise>> getByCategory(String category);
}
