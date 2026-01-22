import 'package:flutter/material.dart';

import '../../core/settings/app_settings.dart';
import '../../models/exercise.dart';
import '../../widgets/exercise_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  ];

  int _workoutsThisWeek = 0;
  final int _weeklyGoal = 5;

  void _addNewExercise() async {
    final result = await Navigator.pushNamed(context, '/exercise/new');

    if (result != null && result is Exercise) {
      setState(() {
        _exercises.add(result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result.name} adicionado!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _removeExercise(String id) {
    setState(() {
      _exercises.removeWhere((e) => e.id == id);
    });
  }

  void _incrementWorkout() {
    setState(() {
      if (_workoutsThisWeek < _weeklyGoal) {
        _workoutsThisWeek++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('FitTracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.timer),
            onPressed: () => Navigator.pushNamed(context, '/timer'),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(settings),
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
                        label: Text('${_exercises.length} exercícios'),
                        backgroundColor: Colors.orange[100],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ..._exercises.map(
                    (exercise) => ExerciseCard(
                      key: ValueKey(exercise.id),
                      exercise: exercise,
                      onDelete: () => _removeExercise(exercise.id),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewExercise,
        icon: Icon(Icons.add),
        label: Text('Novo Exercício'),
      ),
    );
  }

  Widget _buildHeader(AppSettings settings) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: settings.isDarkMode
              ? [Colors.grey[800]!, Colors.grey[900]!]
              : [Colors.orange, Colors.deepOrange],
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
          _buildWorkoutCounter(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWorkoutCounter() {
    double progress = _workoutsThisWeek / _weeklyGoal;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  ' / $_weeklyGoal',
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1 ? Colors.green : Colors.orange,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _incrementWorkout,
              icon: Icon(Icons.check),
              label: Text('Marcar Treino'),
            ),
          ],
        ),
      ),
    );
  }
}
