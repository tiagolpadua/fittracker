import '../entities/exercise.dart';
import '../errors/failures.dart';
import '../repositories/exercise_repository.dart';

class ToggleExerciseComplete {
  final ExerciseRepository repository;

  ToggleExerciseComplete(this.repository);

  Future<Exercise> call(String id) async {
    if (id.isEmpty) {
      throw const ValidationFailure('id', 'ID nao pode ser vazio');
    }
    final exercise = await repository.getById(id);
    if (exercise == null) {
      throw ExerciseNotFoundFailure(id);
    }
    final updated = exercise.copyWith(isCompleted: !exercise.isCompleted);
    await repository.update(updated);
    return updated;
  }
}
