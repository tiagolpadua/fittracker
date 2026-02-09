import 'package:fittracker/modules/stats/stats_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Modulo da feature Estatisticas.
class StatsModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const StatsPage());
  }
}
