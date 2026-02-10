import 'package:fittracker/modules/exercise/excercise_module.dart';
import 'package:fittracker/modules/home/home_module.dart';
import 'package:fittracker/service/exercice_api_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Servicos globais compartilhados entre todos os modulos
    i.addSingleton(ExerciseApiService.new);
    i.addInstance(http.Client());
  }

  @override
  void routes(RouteManager r) {
    r.module('/', module: HomeModule());
    r.module('/exercises', module: ExerciseModule());
    // r.module('/timer', module: TimerModule());
    // r.module('/stats', module: StatsModule());
  }
}
