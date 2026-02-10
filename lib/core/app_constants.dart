/// Constantes da aplicacao FitTracker
class AppConstants {
  // Presets de timer em segundos
  static const List<int> timerPresets = [30, 60, 90, 120];

  // Meta semanal de treinos
  static const int weeklyGoalWorkouts = 5;

  // Duracao de animacoes em ms
  static const int animationDurationMs = 300;
  static const int listAnimationDurationMs = 1500;
  static const int progressAnimationDurationMs = 1000;
  static const int pulseAnimationDurationMs = 1500;

  // Categorias de exercicios
  static const List<String> exerciseCategories = [
    'Peito',
    'Costas',
    'Pernas',
    'Ombros',
    'Bíceps',
    'Tríceps',
    'Abdômen',
    'Cardio',
  ];

  // Limites de validacao
  static const int minExerciseNameLength = 3;
  static const int minSets = 1;
  static const int maxSets = 20;
  static const int minReps = 1;
  static const int maxReps = 100;
  static const double minWeight = 0;
  static const double maxWeight = 500;

  // Rotas da aplicacao (Flutter Modular)
  static const String routeHome = '/';
  static const String routeExercises = '/exercises/';
  static const String routeTimer = '/timer/';
  static const String routeStats = '/stats/';
}
