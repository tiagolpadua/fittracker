import 'package:fittracker/config/settings_provider.dart';
import 'package:fittracker/constants/app_constants.dart';
import 'package:fittracker/models/exercise.dart';
import 'package:fittracker/utils/format_utils.dart';
import 'package:fittracker/widgets/exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// HomeScreen com animacoes
/// Demonstra: AnimationController, Staggered Animations, Tween, Curves
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Controllers de animacao
  late AnimationController _listController;
  late AnimationController _progressController;
  late AnimationController _pulseController;

  // Animacao do progresso
  late Animation<double> _progressAnimation;

  // Estado de conteudo
  bool _showContent = false;

  // Dados
  final List<Exercise> _exercises = [
    Exercise(
      id: '1',
      name: 'Supino Reto',
      sets: 4,
      reps: 12,
      category: 'Peito',
      weight: 60,
    ),
    Exercise(
      id: '2',
      name: 'Agachamento',
      sets: 4,
      reps: 15,
      category: 'Pernas',
      weight: 80,
    ),
    Exercise(
      id: '3',
      name: 'Remada Curvada',
      sets: 3,
      reps: 12,
      category: 'Costas',
      weight: 50,
    ),
    Exercise(
      id: '4',
      name: 'Desenvolvimento',
      sets: 4,
      reps: 10,
      category: 'Ombros',
      weight: 30,
    ),
    Exercise(
      id: '5',
      name: 'Rosca Direta',
      sets: 3,
      reps: 15,
      category: 'Biceps',
      weight: 15,
    ),
  ];

  // Rastrear exercicios completados
  final Set<String> _completedExercises = {};

  int _workoutsThisWeek = 0;
  final int _weeklyGoal = AppConstants.weeklyGoalWorkouts;

  @override
  void initState() {
    super.initState();

    // Controller para lista staggered (1.5s total)
    _listController = AnimationController(
      duration: Duration(milliseconds: AppConstants.listAnimationDurationMs),
      vsync: this,
    );

    // Controller para progresso (1s)
    _progressController = AnimationController(
      duration: Duration(
        milliseconds: AppConstants.progressAnimationDurationMs,
      ),
      vsync: this,
    );

    // Controller para pulse do FAB (loop)
    _pulseController = AnimationController(
      duration: Duration(milliseconds: AppConstants.pulseAnimationDurationMs),
      vsync: this,
    )..repeat(reverse: true);

    // Animacao inicial do progresso
    _progressAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    // Iniciar animacoes apos build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _showContent = true);
      _listController.forward();
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _addNewExercise() async {
    final result = await Navigator.pushNamed(
      context,
      AppConstants.routeNewExercise,
    );

    if (result != null && result is Exercise) {
      setState(() {
        _exercises.add(result);
      });

      // Replay animacao para mostrar novo item
      _listController.reset();
      _listController.forward();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.name} adicionado!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _removeExercise(String id) {
    setState(() {
      _exercises.removeWhere((e) => e.id == id);
      _completedExercises.remove(id);
    });
  }

  void _toggleCompleted(String id) {
    setState(() {
      if (_completedExercises.contains(id)) {
        _completedExercises.remove(id);
      } else {
        _completedExercises.add(id);
      }
    });
  }

  void _incrementWorkout() {
    if (_workoutsThisWeek < _weeklyGoal) {
      final oldProgress = _workoutsThisWeek / _weeklyGoal;
      setState(() {
        _workoutsThisWeek++;
      });
      final newProgress = _workoutsThisWeek / _weeklyGoal;

      // Animar progresso do valor atual para o novo
      _progressAnimation = Tween<double>(begin: oldProgress, end: newProgress)
          .animate(
            CurvedAnimation(
              parent: _progressController,
              curve: Curves.elasticInOut,
            ),
          );
      _progressController.forward(from: 0);
    }
  }

  void _decrementWorkout() {
    if (_workoutsThisWeek > 0) {
      final oldProgress = _workoutsThisWeek / _weeklyGoal;
      setState(() {
        _workoutsThisWeek--;
      });
      final newProgress = _workoutsThisWeek / _weeklyGoal;

      _progressAnimation = Tween<double>(begin: oldProgress, end: newProgress)
          .animate(
            CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
          );
      _progressController.forward(from: 0);
    }
  }

  void _replayListAnimation() {
    _listController.reset();
    _listController.forward();
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(
                  'Configuracoes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Divider(),
              SwitchListTile(
                title: Text('Tema escuro'),
                subtitle: Text('Alterna entre claro e escuro'),
                value: settings.isDark,
                onChanged: (_) => settings.toggleTheme(),
                secondary: Icon(
                  settings.isDark ? Icons.dark_mode : Icons.light_mode,
                ),
              ),
              SwitchListTile(
                title: Text('Mostrar exercicios completos'),
                subtitle: Text('Exibe exercicios ja realizados'),
                value: settings.showCompletedExercises,
                onChanged: (_) => settings.toggleShowCompleted(),
                secondary: Icon(Icons.visibility),
              ),
              ListTile(
                leading: Icon(Icons.straighten),
                title: Text('Unidade de medida'),
                subtitle: Text(settings.measurementUnit),
                trailing: DropdownButton<String>(
                  value: settings.measurementUnit,
                  items: ['kg', 'lb'].map((unit) {
                    return DropdownMenuItem(value: unit, child: Text(unit));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settings.setMeasurementUnit(value);
                    }
                  },
                ),
              ),
              SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Color _getProgressColor(double progress) {
    return FormatUtils.getProgressColor(progress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar animada
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('FitTracker'),
                background: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                  ),
                  child: Center(
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 800),
                      opacity: _showContent ? 1 : 0,
                      child: Icon(
                        Icons.fitness_center,
                        size: 80,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: _replayListAnimation,
                  tooltip: 'Replay animacao',
                ),
                IconButton(
                  icon: Icon(Icons.timer),
                  onPressed: () =>
                      Navigator.pushNamed(context, AppConstants.routeTimer),
                  tooltip: 'Timer',
                ),
                Selector<SettingsProvider, bool>(
                  selector: (_, settings) => settings.isDark,
                  builder: (context, isDark, child) {
                    return IconButton(
                      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                      onPressed: () =>
                          context.read<SettingsProvider>().toggleTheme(),
                      tooltip: 'Alternar tema',
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => _showSettingsSheet(context),
                  tooltip: 'Configuracoes',
                ),
              ],
            ),

            // Conteudo
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card de Progresso Animado
                    _buildProgressCard(),

                    SizedBox(height: 24),

                    // Titulo da lista com fade
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: _showContent ? 1 : 0,
                      child: Consumer<SettingsProvider>(
                        builder: (context, settings, child) {
                          final displayCount = settings.showCompletedExercises
                              ? _exercises.length
                              : _exercises.length - _completedExercises.length;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Treino de Hoje',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '$displayCount exercicios',
                                  style: TextStyle(
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 16),

                    // Lista de exercicios com staggered animation
                    _buildStaggeredList(),

                    // Mensagem se lista vazia
                    Consumer<SettingsProvider>(
                      builder: (context, settings, child) {
                        final isEmpty =
                            _exercises.isEmpty ||
                            (!settings.showCompletedExercises &&
                                _exercises.length ==
                                    _completedExercises.length);
                        if (!isEmpty) return SizedBox.shrink();

                        return AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: _showContent ? 1 : 0,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.fitness_center,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    _exercises.isEmpty
                                        ? 'Nenhum exercicio cadastrado'
                                        : 'Todos os exercicios foram completados!',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _exercises.isEmpty
                                        ? 'Toque no botao + para adicionar'
                                        : 'Desabilite a opcao para ver exercicios completos',
                                    style: TextStyle(color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAnimatedFAB(),
    );
  }

  /// Card de progresso com animacao explicita (AnimationController)
  Widget _buildProgressCard() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 600),
      opacity: _showContent ? 1 : 0,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Progresso Semanal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 24),

              // Progresso circular animado
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  // Calcular progresso visual
                  final displayProgress = _progressController.isAnimating
                      ? _progressAnimation.value
                      : _workoutsThisWeek / _weeklyGoal;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: displayProgress,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(displayProgress),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TweenAnimationBuilder<int>(
                            tween: IntTween(begin: 0, end: _workoutsThisWeek),
                            duration: Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return Text(
                                '$value',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: _getProgressColor(
                                    _workoutsThisWeek / _weeklyGoal,
                                  ),
                                ),
                              );
                            },
                          ),
                          Text(
                            'de $_weeklyGoal',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 24),

              // Botoes de controle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botao diminuir
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    child: ElevatedButton.icon(
                      onPressed: _workoutsThisWeek > 0
                          ? _decrementWorkout
                          : null,
                      icon: Icon(Icons.remove),
                      label: Text('Remover'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Botao aumentar
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: _workoutsThisWeek >= _weeklyGoal ? 180 : 160,
                    child: ElevatedButton.icon(
                      onPressed: _workoutsThisWeek >= _weeklyGoal
                          ? null
                          : _incrementWorkout,
                      icon: Icon(
                        _workoutsThisWeek >= _weeklyGoal
                            ? Icons.check
                            : Icons.add,
                      ),
                      label: Text(
                        _workoutsThisWeek >= _weeklyGoal
                            ? 'Meta Atingida!'
                            : 'Concluir',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _workoutsThisWeek >= _weeklyGoal
                            ? Colors.green
                            : Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Lista com staggered animation (cada item aparece em sequencia)
  Widget _buildStaggeredList() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        // Filtrar exercicios baseado na configuracao
        final filteredExercises = _exercises.where((exercise) {
          if (!settings.showCompletedExercises) {
            return !_completedExercises.contains(exercise.id);
          }
          return true;
        }).toList();

        return AnimatedBuilder(
          animation: _listController,
          builder: (context, child) {
            return Column(
              children: List.generate(filteredExercises.length, (index) {
                // Calcular intervalo para cada item (escalonado)
                final startInterval = index * 0.1;
                final endInterval = (startInterval + 0.4).clamp(0.0, 1.0);

                // Animacao de slide da direita
                final slideAnimation =
                    Tween<Offset>(
                      begin: Offset(1, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _listController,
                        curve: Interval(
                          startInterval,
                          endInterval,
                          curve: Curves.easeOut,
                        ),
                      ),
                    );

                // Animacao de fade
                final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _listController,
                    curve: Interval(startInterval, endInterval),
                  ),
                );

                final exercise = filteredExercises[index];
                final isCompleted = _completedExercises.contains(exercise.id);

                return SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: ExerciseCard(
                      key: ValueKey(exercise.id),
                      exercise: exercise,
                      isCompleted: isCompleted,
                      onDelete: () => _removeExercise(exercise.id),
                      onToggleCompleted: () => _toggleCompleted(exercise.id),
                    ),
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }

  /// FAB com animacao de pulse
  Widget _buildAnimatedFAB() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + (_pulseController.value * 0.1),
          child: FloatingActionButton.extended(
            onPressed: _addNewExercise,
            icon: Icon(Icons.add),
            label: Text('Novo Exercicio'),
            backgroundColor: Colors.orange,
          ),
        );
      },
    );
  }
}
