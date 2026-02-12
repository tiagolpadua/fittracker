import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

import 'domain/repositories/exercise_repository.dart';
import 'domain/usecases/add_exercise.dart';
import 'domain/usecases/get_exercise_by_id.dart';
import 'domain/usecases/get_exercises.dart';
import 'domain/usecases/remove_exercise.dart';
import 'domain/usecases/toggle_exercise_complete.dart';
import 'external/datasources/exercise_datasource_http.dart';
import 'infra/datasources/exercise_datasource.dart';
import 'infra/repositories/exercise_repository_impl.dart';
import 'presenter/controllers/exercise_controller.dart';
import 'presenter/pages/exercise_detail_page.dart';
import 'presenter/pages/exercise_list_page.dart';

/// Modulo da feature Exercicios.
class ExerciseModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<ExerciseDataSource>(
      () => ExerciseDataSourceHttp(i.get<http.Client>()),
    );

    i.addSingleton<ExerciseRepository>(
      () => ExerciseRepositoryImpl(i.get<ExerciseDataSource>()),
    );

    i.add(() => GetExercises(i.get<ExerciseRepository>()));
    i.add(() => GetExerciseById(i.get<ExerciseRepository>()));
    i.add(() => AddExercise(i.get<ExerciseRepository>()));
    i.add(() => RemoveExercise(i.get<ExerciseRepository>()));
    i.add(() => ToggleExerciseComplete(i.get<ExerciseRepository>()));

    i.add(
      () => ExerciseController(
        getExercises: i.get<GetExercises>(),
        getExerciseById: i.get<GetExerciseById>(),
        addExercise: i.get<AddExercise>(),
        removeExercise: i.get<RemoveExercise>(),
        toggleComplete: i.get<ToggleExerciseComplete>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const ExerciseListPage());
    r.child(
      '/:id',
      child: (context) => ExerciseDetailPage(id: r.args.params['id'] ?? ''),
    );
  }
}
