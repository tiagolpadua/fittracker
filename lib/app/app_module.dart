import 'package:fittracker/app/modules/exercise/exercise_module.dart';
import 'package:fittracker/app/modules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Servicos globais compartilhados entre todos os modulos
    // i.addInstance<http.Client>(http.Client());
    i.addSingleton(() => http.Client());
  }

  @override
  void routes(RouteManager r) {
    r.module('/', module: HomeModule());
    r.module('/exercises', module: ExerciseModule());
    // r.module('/timer', module: TimerModule());
    // r.module('/stats', module: StatsModule());
  }
}
