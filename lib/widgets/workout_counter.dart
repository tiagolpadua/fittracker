import 'package:flutter/material.dart';

class WorkoutCounter extends StatefulWidget {
  const WorkoutCounter({super.key});

  @override
  State<WorkoutCounter> createState() => _WorkoutCounterState();
}

class _WorkoutCounterState extends State<WorkoutCounter> {
  int _workoutsThisWeek = 0;
  final _weeklyGoal = 5;

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
    print("Passou pelo build...");
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Treinos desta Semana',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
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
                  '/ $_weeklyGoal',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
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
                  label: Text("Remover"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[800],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _incrementWorkout,
                  icon: Icon(Icons.add),
                  label: Text("Adicionar"),
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
