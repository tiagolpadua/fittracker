import 'package:fittracker/modules/home/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Modulo da feature Home.
class HomeModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage());
  }
}
