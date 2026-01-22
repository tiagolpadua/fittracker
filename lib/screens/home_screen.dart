import 'package:fittracker/widgets/workout_counter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    debugPrint('HomeScreen: dispose()');
    super.dispose();
  }

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
            icon: const Icon(Icons.timer),
            onPressed: () {
              Navigator.pushNamed(context, '/timer');
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Icon(Icons.fitness_center, size: 48),
              SizedBox(height: 8),
              Text(
                "Meus Treinos",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              WorkoutCounter(),
            ],
          ),
        ),
      ),
    );
  }
}
