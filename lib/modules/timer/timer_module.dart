import 'package:fittracker/modules/timer/timer_page.dart';
import 'package:fittracker/modules/timer/timer_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Modulo da feature Timer de Descanso.
///
/// Registra o [TimerService] como Lazy Singleton
/// (so e criado quando acessado pela primeira vez).
class TimerModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(TimerService.new);
  }

  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const TimerPage());
  }
}
