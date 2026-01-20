import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(FitTrackerApp());
}

// ========================================
// APP PRINCIPAL
// ========================================
class FitTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
      ),
      home: HomeScreen(),
    );
  }
}

// ========================================
// MODELO DE DADOS
// ========================================
class Exercise {
  final String name;
  final int sets;
  final int reps;
  final String category;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.category,
  });
}

// Modelo para histórico de descansos
class RestRecord {
  final int seconds;
  final DateTime time;

  RestRecord({required this.seconds, required this.time});
}

// ========================================
// TELA HOME (sem alterações da aula 1)
// ========================================
class HomeScreen extends StatelessWidget {
  final List<Exercise> exercises = [
    Exercise(name: 'Supino Reto', sets: 4, reps: 12, category: 'Peito'),
    Exercise(name: 'Agachamento', sets: 4, reps: 15, category: 'Pernas'),
    Exercise(name: 'Remada Curvada', sets: 3, reps: 12, category: 'Costas'),
    Exercise(name: 'Desenvolvimento', sets: 3, reps: 10, category: 'Ombros'),
    Exercise(name: 'Rosca Direta', sets: 3, reps: 12, category: 'Bíceps'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FitTracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.timer),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimerScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Icon(Icons.fitness_center, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Meus Treinos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  WorkoutCounter(),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // Lista de exercícios
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Treino de Hoje',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text('${exercises.length} exercícios'),
                        backgroundColor: Colors.orange[100],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ...exercises
                      .asMap()
                      .entries
                      .map(
                        (entry) => ExerciseCard(
                          exercise: entry.value,
                          index: entry.key,
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Treino iniciado!'),
              backgroundColor: Colors.green,
            ),
          );
        },
        icon: Icon(Icons.play_arrow),
        label: Text('Iniciar'),
      ),
    );
  }
}

// ========================================
// WORKOUT COUNTER (sem alterações)
// ========================================
class WorkoutCounter extends StatefulWidget {
  @override
  _WorkoutCounterState createState() => _WorkoutCounterState();
}

class _WorkoutCounterState extends State<WorkoutCounter> {
  int _workoutsThisWeek = 0;
  final int _weeklyGoal = 5;

  void _incrementWorkout() {
    setState(() {
      if (_workoutsThisWeek < _weeklyGoal) {
        _workoutsThisWeek++;
      }
    });
  }

  void _decrementWorkout() {
    setState(() {
      if (_workoutsThisWeek > 0) {
        _workoutsThisWeek--;
      }
    });
  }

  double get _progress => _workoutsThisWeek / _weeklyGoal;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Treinos desta Semana',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_workoutsThisWeek',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  ' / $_weeklyGoal',
                  style: TextStyle(fontSize: 32, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _workoutsThisWeek >= _weeklyGoal
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _decrementWorkout,
                  icon: Icon(Icons.remove),
                  label: Text('Remover'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: _incrementWorkout,
                  icon: Icon(Icons.add),
                  label: Text('Adicionar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ========================================
// EXERCISE CARD (sem alterações)
// ========================================
class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final int index;

  ExerciseCard({required this.exercise, required this.index});

  Color _getCategoryColor() {
    switch (exercise.category.toLowerCase()) {
      case 'peito':
        return Colors.red;
      case 'costas':
        return Colors.blue;
      case 'pernas':
        return Colors.green;
      case 'ombros':
        return Colors.purple;
      case 'bíceps':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getCategoryColor().withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getCategoryColor(),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    exercise.category,
                    style: TextStyle(fontSize: 12, color: _getCategoryColor()),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${exercise.sets}x${exercise.reps}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================================
// TIMER SCREEN - VERSÃO EXPANDIDA
// ========================================
// Este é o foco da aula 3!
// Demonstra ciclo de vida completo do StatefulWidget

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // Estado do timer
  int _remainingSeconds = 60;
  int _selectedSeconds = 60;
  Timer? _timer;
  bool _isRunning = false;

  // Histórico de descansos
  List<RestRecord> _history = [];

  // Presets disponíveis (em segundos)
  final List<int> _presets = [30, 60, 90, 120];

  // ============ CICLO DE VIDA ============

  @override
  void initState() {
    super.initState();
    // Chamado uma vez quando o widget é criado
    // Use para inicialização
    debugPrint('TimerScreen: initState()');
  }

  @override
  void dispose() {
    // Chamado quando o widget é removido
    // IMPORTANTE: Sempre cancele timers aqui!
    debugPrint('TimerScreen: dispose()');
    _timer?.cancel();
    super.dispose();
  }

  // ============ MÉTODOS DO TIMER ============

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // IMPORTANTE: Verificar mounted antes de setState
      // Evita erros se o widget foi removido durante o callback
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _onTimerComplete();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _selectedSeconds;
    });
  }

  void _selectPreset(int seconds) {
    _timer?.cancel();
    setState(() {
      _selectedSeconds = seconds;
      _remainingSeconds = seconds;
      _isRunning = false;
    });
  }

  void _onTimerComplete() {
    _timer?.cancel();

    setState(() {
      _isRunning = false;
      // Adiciona ao histórico
      _history.add(RestRecord(seconds: _selectedSeconds, time: DateTime.now()));
      // Reseta para o tempo selecionado
      _remainingSeconds = _selectedSeconds;
    });

    // Mostra feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Descanso completo! Hora de treinar!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  // ============ HELPERS ============

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _formatPreset(int seconds) {
    if (seconds >= 60) {
      int mins = seconds ~/ 60;
      int secs = seconds % 60;
      return secs > 0 ? '${mins}m${secs}s' : '${mins}min';
    }
    return '${seconds}s';
  }

  double get _progress {
    if (_selectedSeconds == 0) return 0;
    return _remainingSeconds / _selectedSeconds;
  }

  // ============ BUILD ============

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer de Descanso')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20),

              // Seletor de tempo
              Text(
                'Selecione o tempo:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: _presets.map((seconds) {
                  bool isSelected = _selectedSeconds == seconds;
                  return ChoiceChip(
                    label: Text(_formatPreset(seconds)),
                    selected: isSelected,
                    selectedColor: Colors.orange,
                    onSelected: _isRunning
                        ? null
                        : (_) => _selectPreset(seconds),
                  );
                }).toList(),
              ),

              SizedBox(height: 40),

              // Timer circular
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _remainingSeconds <= 10 ? Colors.red : Colors.orange,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isRunning ? Icons.timer : Icons.timer_outlined,
                        size: 32,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _remainingSeconds <= 10
                              ? Colors.red
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 40),

              // Botões de controle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão Reset
                  FloatingActionButton(
                    heroTag: 'reset',
                    onPressed: _resetTimer,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.refresh),
                  ),
                  SizedBox(width: 20),
                  // Botão Play/Pause
                  FloatingActionButton.large(
                    heroTag: 'playPause',
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    backgroundColor: _isRunning ? Colors.red : Colors.green,
                    child: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 20),
                  // Botão Skip (completa o timer)
                  FloatingActionButton(
                    heroTag: 'skip',
                    onPressed: _isRunning ? _onTimerComplete : null,
                    backgroundColor: _isRunning
                        ? Colors.orange
                        : Colors.grey[300],
                    child: Icon(Icons.skip_next),
                  ),
                ],
              ),

              SizedBox(height: 40),

              // Histórico de descansos
              if (_history.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Histórico de Descansos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(onPressed: _clearHistory, child: Text('Limpar')),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      // Mostra do mais recente para o mais antigo
                      final record = _history[_history.length - 1 - index];
                      return Container(
                        margin: EdgeInsets.only(right: 12),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatPreset(record.seconds),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[800],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${record.time.hour}:${record.time.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
