import 'package:fittracker/modules/exercise/exercise_module.dart';
import 'package:fittracker/modules/home/home_module.dart';
import 'package:fittracker/modules/stats/stats_module.dart';
import 'package:fittracker/modules/timer/timer_module.dart';
import 'package:fittracker/modules/exercise/exercise_api_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Modulo principal do FitTracker.
///
/// Registra os servicos globais (Singletons) e define
/// as rotas de cada feature module.
class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Servicos globais compartilhados entre todos os modulos
    i.addSingleton(ExerciseApiService.new);
  }

  @override
  void routes(RouteManager r) {
    r.module('/', module: HomeModule());
    r.module('/exercises', module: ExerciseModule());
    r.module('/timer', module: TimerModule());
    r.module('/stats', module: StatsModule());
  }
}
