import '../models/exercise_model.dart';

/// Interface de acesso a dados de exercicios.
abstract class ExerciseDataSource {
  Future<List<ExerciseModel>> getAll();
  Future<ExerciseModel?> getById(String id);
  Future<void> save(ExerciseModel exercise);
  Future<void> delete(String id);
}
