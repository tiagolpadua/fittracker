import '../../domain/entities/exercise.dart';

/// Model com capacidade de serializacao JSON.
class ExerciseModel extends Exercise {
  const ExerciseModel({
    required super.id,
    required super.name,
    required super.sets,
    required super.reps,
    required super.category,
    super.weight,
    super.isCompleted,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      category: json['category'] as String,
      weight: json['weight'] != null
          ? (json['weight'] as num).toDouble()
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'category': category,
      'weight': weight,
      'isCompleted': isCompleted,
    };
  }

  factory ExerciseModel.fromEntity(Exercise entity) {
    return ExerciseModel(
      id: entity.id,
      name: entity.name,
      sets: entity.sets,
      reps: entity.reps,
      category: entity.category,
      weight: entity.weight,
      isCompleted: entity.isCompleted,
    );
  }
}
