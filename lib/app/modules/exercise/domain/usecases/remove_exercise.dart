import '../errors/failures.dart';
import '../repositories/exercise_repository.dart';

class RemoveExercise {
  final ExerciseRepository repository;

  RemoveExercise(this.repository);

  Future<void> call(String id) async {
    if (id.isEmpty) {
      throw const ValidationFailure('id', 'ID nao pode ser vazio');
    }
    await repository.remove(id);
  }
}
