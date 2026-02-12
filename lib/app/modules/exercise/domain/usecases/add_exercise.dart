import '../entities/exercise.dart';
import '../errors/failures.dart';
import '../repositories/exercise_repository.dart';

class AddExercise {
  final ExerciseRepository repository;

  AddExercise(this.repository);

  Future<void> call(Exercise exercise) async {
    if (exercise.name.isEmpty) {
      throw const ValidationFailure('name', 'Nome nao pode ser vazio');
    }
    if (exercise.sets <= 0 || exercise.reps <= 0) {
      throw const ValidationFailure('sets/reps', 'Valores devem ser > 0');
    }
    await repository.add(exercise);
  }
}
