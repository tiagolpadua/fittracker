import 'package:fittracker/constants/app_constants.dart';
import 'package:fittracker/models/exercise.dart';
import 'package:flutter/material.dart';

class NewExerciseScreen extends StatefulWidget {
  const NewExerciseScreen({super.key});

  @override
  State<NewExerciseScreen> createState() => _NewExerciseScreenState();
}

class _NewExerciseScreenState extends State<NewExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();

  String? _selectedCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newExercise = Exercise(
        name: _nameController.text.trim(),
        sets: int.parse(_setsController.text),
        reps: int.parse(_repsController.text),
        category: _selectedCategory!,
        weight: _weightController.text.isNotEmpty
            ? double.parse(_weightController.text)
            : null,
      );

      Navigator.pop(context, newExercise);
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _setsController.clear();
    _repsController.clear();
    _weightController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final settings = AppSettings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Exercício'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _clearForm,
            tooltip: 'Limpar formulário',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.fitness_center, size: 64, color: Colors.orange),
              SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Exercício',
                  hintText: 'Ex: Supino Reto',
                  prefixIcon: Icon(Icons.edit),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira o nome do exercício';
                  }
                  if (value.trim().length <
                      AppConstants.minExerciseNameLength) {
                    return 'Nome deve ter pelo menos ${AppConstants.minExerciseNameLength} caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _setsController,
                      decoration: InputDecoration(
                        labelText: 'Séries',
                        hintText: 'Ex: 4',
                        prefixIcon: Icon(Icons.repeat),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obrigatório';
                        }
                        final number = int.tryParse(value);
                        if (number == null) {
                          return 'Número inválido';
                        }
                        if (number < AppConstants.minSets ||
                            number > AppConstants.maxSets) {
                          return 'Entre ${AppConstants.minSets} e ${AppConstants.maxSets}';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      decoration: InputDecoration(
                        labelText: 'Repetições',
                        hintText: 'Ex: 12',
                        prefixIcon: Icon(Icons.tag),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obrigatório';
                        }
                        final number = int.tryParse(value);
                        if (number == null) {
                          return 'Número inválido';
                        }
                        if (number < AppConstants.minReps ||
                            number > AppConstants.maxReps) {
                          return 'Entre ${AppConstants.minReps} e ${AppConstants.maxReps}';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Peso (kg) - Opcional',
                  hintText: 'Ex: 50',
                  prefixIcon: Icon(Icons.fitness_center),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final number = double.tryParse(value);
                    if (number == null) {
                      return 'Número inválido';
                    }
                    if (number < AppConstants.minWeight ||
                        number > AppConstants.maxWeight) {
                      return 'Peso deve estar entre ${AppConstants.minWeight} e ${AppConstants.maxWeight}';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: AppConstants.exerciseCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(Icons.check),
                label: Text('Cadastrar Exercício'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Cancelar'),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
