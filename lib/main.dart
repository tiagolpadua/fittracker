// FITTRACKER - VERSÃO COMPLETA E SIMPLIFICADA PARA AULA
// Copie este arquivo para lib/main.dart do seu projeto Flutter
// Execute com: flutter run

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

// ========================================
// TELA HOME
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header com contador
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
                    ...exercises.asMap().entries.map(
                      (entry) =>
                          ExerciseCard(exercise: entry.value, index: entry.key),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Treino iniciado! Bora treinar! 💪'),
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
// WIDGET: CONTADOR DE TREINOS (STATEFUL)
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

  String _getMotivationalMessage() {
    if (_workoutsThisWeek == 0) {
      return 'Vamos começar! Todo treino conta! 💪';
    } else if (_workoutsThisWeek < _weeklyGoal) {
      return 'Continue assim! Faltam ${_weeklyGoal - _workoutsThisWeek} treinos!';
    } else {
      return 'Meta atingida! Você é incrível! 🎉';
    }
  }

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

            // Contador
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

            // Barra de progresso
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

            SizedBox(height: 16),

            // Mensagem
            Text(
              _getMotivationalMessage(),
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            // Botões
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
// WIDGET: CARD DE EXERCÍCIO (STATELESS)
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

  IconData _getCategoryIcon() {
    switch (exercise.category.toLowerCase()) {
      case 'peito':
        return Icons.favorite;
      case 'costas':
        return Icons.arrow_back;
      case 'pernas':
        return Icons.directions_run;
      case 'ombros':
        return Icons.accessibility_new;
      default:
        return Icons.fitness_center;
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
            // Número
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

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _getCategoryIcon(),
                        size: 14,
                        color: _getCategoryColor(),
                      ),
                      SizedBox(width: 4),
                      Text(
                        exercise.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getCategoryColor(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Séries
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

            SizedBox(width: 8),

            // Check
            IconButton(
              icon: Icon(Icons.check_circle_outline),
              color: Colors.grey,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${exercise.name} completo! ✓'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ========================================
// TELA: TIMER DE DESCANSO (STATEFUL)
// ========================================
class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _remainingSeconds = 60;
  int _initialSeconds = 60;
  Timer? _timer;
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _stopTimer();
          _showCompletionDialog();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _remainingSeconds = _initialSeconds;
    });
  }

  void _setTime(int seconds) {
    setState(() {
      _initialSeconds = seconds;
      _remainingSeconds = seconds;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Descanso Completo!'),
        content: Text('Hora de voltar ao treino! 💪'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double get _progress =>
      _initialSeconds > 0 ? _remainingSeconds / _initialSeconds : 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer de Descanso')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tempo de Descanso',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),

            // Timer circular
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _remainingSeconds <= 10 ? Colors.red : Colors.orange,
                    ),
                  ),
                ),
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: _remainingSeconds <= 10 ? Colors.red : Colors.orange,
                  ),
                ),
              ],
            ),

            SizedBox(height: 60),

            // Botões
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.large(
                  onPressed: _isRunning ? _stopTimer : _startTimer,
                  backgroundColor: _isRunning ? Colors.red : Colors.green,
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    size: 40,
                  ),
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: _resetTimer,
                  backgroundColor: Colors.grey[700],
                  child: Icon(Icons.refresh),
                ),
              ],
            ),

            SizedBox(height: 60),

            // Tempos rápidos
            Text('Tempos Rápidos', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                _buildTimeChip('30s', 30),
                _buildTimeChip('60s', 60),
                _buildTimeChip('90s', 90),
                _buildTimeChip('2min', 120),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(String label, int seconds) {
    bool isSelected = _initialSeconds == seconds;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _setTime(seconds),
      selectedColor: Colors.orange,
    );
  }
}
