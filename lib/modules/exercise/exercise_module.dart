import 'package:fittracker/modules/exercise/exercise_detail_page.dart';
import 'package:fittracker/modules/exercise/exercise_list_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Modulo da feature Exercicios.
///
/// Contem a lista e o detalhe de cada exercicio.
class ExerciseModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const ExerciseListPage());
    r.child(
      '/:id',
      child: (context) => ExerciseDetailPage(id: r.args.params['id'] ?? ''),
    );
  }
}
