import '../../domain/entities/exercise.dart';
import '../../domain/errors/failures.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_datasource.dart';
import '../models/exercise_model.dart';

/// Implementacao do repositorio usando o DataSource.
class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseDataSource dataSource;

  ExerciseRepositoryImpl(this.dataSource);

  @override
  Future<List<Exercise>> getAll() async {
    try {
      final models = await dataSource.getAll();
      return models.cast<Exercise>();
    } catch (e) {
      throw DataSourceFailure(e.toString());
    }
  }

  @override
  Future<Exercise?> getById(String id) async {
    try {
      return await dataSource.getById(id);
    } catch (e) {
      throw DataSourceFailure(e.toString());
    }
  }

  @override
  Future<void> add(Exercise exercise) async {
    try {
      await dataSource.save(ExerciseModel.fromEntity(exercise));
    } catch (e) {
      throw DataSourceFailure(e.toString());
    }
  }

  @override
  Future<void> update(Exercise exercise) async {
    try {
      await dataSource.save(ExerciseModel.fromEntity(exercise));
    } catch (e) {
      throw DataSourceFailure(e.toString());
    }
  }

  @override
  Future<void> remove(String id) async {
    try {
      await dataSource.delete(id);
    } catch (e) {
      throw DataSourceFailure(e.toString());
    }
  }

  @override
  Future<List<Exercise>> getByCategory(String category) async {
    final all = await getAll();
    return all.where((e) => e.category == category).toList();
  }
}
