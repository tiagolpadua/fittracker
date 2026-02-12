import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';

class GetExercises {
  final ExerciseRepository repository;

  GetExercises(this.repository);

  Future<List<Exercise>> call() => repository.getAll();
}
