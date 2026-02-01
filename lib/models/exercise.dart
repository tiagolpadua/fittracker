class Exercise {
  final String? id;
  final String name;
  final int sets;
  final int reps;
  final String category;
  final double? weight;
  bool isCompleted;

  Exercise({
    this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.category,
    this.weight,
    this.isCompleted = false,
  });

  /// Cria um Exercise a partir de um Map JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id']?.toString(),
      name: json['name'] as String? ?? '',
      sets: json['sets'] as int? ?? 0,
      reps: json['reps'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      weight: (json['weight'] as num?)?.toDouble(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// Converte o Exercise para um Map JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'category': category,
      if (weight != null) 'weight': weight,
      'isCompleted': isCompleted,
    };
  }

  /// Cria uma copia do Exercise com valores opcionais alterados
  Exercise copyWith({
    String? id,
    String? name,
    int? sets,
    int? reps,
    String? category,
    double? weight,
    bool? isCompleted,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      category: category ?? this.category,
      weight: weight ?? this.weight,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
