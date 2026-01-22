class Exercise {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final String category;
  final double? weight;

  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.category,
    this.weight,
  });
}
