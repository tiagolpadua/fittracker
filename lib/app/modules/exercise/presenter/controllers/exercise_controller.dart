import 'package:flutter/foundation.dart';

import '../../domain/entities/exercise.dart';
import '../../domain/errors/failures.dart';
import '../../domain/usecases/add_exercise.dart';
import '../../domain/usecases/get_exercise_by_id.dart';
import '../../domain/usecases/get_exercises.dart';
import '../../domain/usecases/remove_exercise.dart';
import '../../domain/usecases/toggle_exercise_complete.dart';

class ExerciseController extends ChangeNotifier {
  final GetExercises getExercises;
  final GetExerciseById getExerciseById;
  final AddExercise addExercise;
  final RemoveExercise removeExercise;
  final ToggleExerciseComplete toggleComplete;

  List<Exercise> exercises = [];
  bool isLoading = false;
  String? errorMessage;

  ExerciseController({
    required this.getExercises,
    required this.getExerciseById,
    required this.addExercise,
    required this.removeExercise,
    required this.toggleComplete,
  });

  Future<void> loadExercises() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      exercises = await getExercises.call();
    } on Failure catch (failure) {
      errorMessage = failure.message;
    } catch (e) {
      errorMessage = 'Erro desconhecido: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Exercise?> loadById(String id) async {
    try {
      return await getExerciseById.call(id);
    } on Failure catch (failure) {
      errorMessage = failure.message;
      notifyListeners();
      return null;
    } catch (e) {
      errorMessage = 'Erro desconhecido: $e';
      notifyListeners();
      return null;
    }
  }

  Future<void> addNewExercise(Exercise exercise) async {
    try {
      await addExercise.call(exercise);
      await loadExercises();
    } on Failure catch (failure) {
      errorMessage = failure.message;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Erro desconhecido: $e';
      notifyListeners();
    }
  }

  Future<void> removeById(String id) async {
    try {
      await removeExercise.call(id);
      exercises.removeWhere((e) => e.id == id);
      notifyListeners();
    } on Failure catch (failure) {
      errorMessage = failure.message;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Erro desconhecido: $e';
      notifyListeners();
    }
  }

  Future<void> toggleExerciseComplete(String id) async {
    try {
      await toggleComplete.call(id);
      await loadExercises();
    } on Failure catch (failure) {
      errorMessage = failure.message;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Erro desconhecido: $e';
      notifyListeners();
    }
  }

  Map<String, int> get stats {
    final total = exercises.length;
    final completed = exercises.where((e) => e.isCompleted).length;
    final totalSets = exercises.fold<int>(0, (sum, e) => sum + e.sets);
    final totalReps = exercises.fold<int>(
      0,
      (sum, e) => sum + (e.sets * e.reps),
    );
    final categories = exercises.map((e) => e.category).toSet().length;

    return {
      'total': total,
      'completed': completed,
      'totalSets': totalSets,
      'totalReps': totalReps,
      'categories': categories,
    };
  }
}
