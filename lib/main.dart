// FitTracker - Aula 09: Pacotes, Plugins e Modularizacao (Flutter Modular)
//
// Demonstra:
// - Estrutura modular com Flutter Modular
// - Separacao de modelos em pacote externo (fittracker_core)
// - Injecao de dependencias via Modular binds
// - Navegacao modularizada com Modular.to
// - Servicos compartilhados (ExerciseApiService, TimerService)

import 'package:fittracker/app_module.dart';
import 'package:fittracker/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
