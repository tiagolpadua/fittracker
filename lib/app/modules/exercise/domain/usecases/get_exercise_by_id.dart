import '../entities/exercise.dart';
import '../errors/failures.dart';
import '../repositories/exercise_repository.dart';

class GetExerciseById {
  final ExerciseRepository repository;

  GetExerciseById(this.repository);

  Future<Exercise?> call(String id) async {
    if (id.isEmpty) {
      throw const ValidationFailure('id', 'ID nao pode ser vazio');
    }
    return repository.getById(id);
  }
}
