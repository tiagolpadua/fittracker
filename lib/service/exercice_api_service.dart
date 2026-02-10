import 'dart:convert';

import 'package:fittracker_core/fittracker_core.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;

class ExerciseApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000';

  final _client = Modular.get<http.Client>();

  Future<List<Exercise>> getAll() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/exercicios'),
      headers: {'Content-Type': 'application/json'},
    );
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Exercise.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> getStats() async {
    final exercises = await getAll();
    final completed = exercises.where((e) => e.isCompleted).length;

    return {
      'total': exercises.length,
      'completed': completed,
      'totalSets': exercises.fold<int>(0, (sum, e) => sum + e.sets),
      'totalReps': exercises.fold<int>(0, (sum, e) => sum + (e.sets * e.reps)),
      'categories': exercises.map((e) => e.category).toSet().length,
    };
  }

  Future<Exercise?> getById(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/exercicios/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 404) return null;
      return Exercise.fromJson(json.decode(response.body));
    } catch (_) {
      return null;
    }
  }
}
