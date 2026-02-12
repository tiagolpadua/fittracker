import 'package:flutter_modular/flutter_modular.dart';

import 'home_page.dart';

/// Modulo da feature Home.
class HomeModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const HomePage());
  }
}
