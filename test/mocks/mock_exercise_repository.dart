import 'package:mockito/mockito.dart';
import 'package:fittracker/app/modules/exercise/domain/entities/exercise.dart';
import 'package:fittracker/app/modules/exercise/domain/repositories/exercise_repository.dart';

/// Mock manual do ExerciseRepository com null safety.
/// Sobrescreve metodos para retornar valores padrao compativeis com null safety,
/// evitando 'type Null is not a subtype of Future<...>'.
/// Nao precisa de @GenerateMocks nem build_runner.
class MockExerciseRepository extends Mock implements ExerciseRepository {
  @override
  Future<List<Exercise>> getAll() =>
      super.noSuchMethod(
        Invocation.method(#getAll, []),
        returnValue: Future.value(<Exercise>[]),
      ) as Future<List<Exercise>>;

  @override
  Future<Exercise?> getById(String id) =>
      super.noSuchMethod(
        Invocation.method(#getById, [id]),
        returnValue: Future.value(null),
      ) as Future<Exercise?>;

  @override
  Future<void> add(Exercise exercise) =>
      super.noSuchMethod(
        Invocation.method(#add, [exercise]),
        returnValue: Future.value(),
      ) as Future<void>;

  @override
  Future<void> update(Exercise exercise) =>
      super.noSuchMethod(
        Invocation.method(#update, [exercise]),
        returnValue: Future.value(),
      ) as Future<void>;

  @override
  Future<void> remove(String id) =>
      super.noSuchMethod(
        Invocation.method(#remove, [id]),
        returnValue: Future.value(),
      ) as Future<void>;

  @override
  Future<List<Exercise>> getByCategory(String category) =>
      super.noSuchMethod(
        Invocation.method(#getByCategory, [category]),
        returnValue: Future.value(<Exercise>[]),
      ) as Future<List<Exercise>>;
}
