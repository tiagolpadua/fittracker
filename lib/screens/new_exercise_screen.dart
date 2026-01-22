import 'package:flutter/material.dart';

class NewExerciseScreen extends StatefulWidget {
  const NewExerciseScreen({super.key});

  @override
  State<NewExerciseScreen> createState() => _NewExerciseScreenState();
}

class _NewExerciseScreenState extends State<NewExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Exercício')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Text('New Exercise Screen - To be implemented'),
        ),
      ),
    );
  }
}
