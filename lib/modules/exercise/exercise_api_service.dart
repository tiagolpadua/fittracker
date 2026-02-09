import 'dart:convert';
import 'dart:io';

import 'package:fittracker_core/fittracker_core.dart';
import 'package:http/http.dart' as http;

/// Servico para gerenciar exercicios via API REST (json-server).
///
/// Registrado como Singleton no [AppModule] via Flutter Modular.
/// Utiliza o endpoint `/exercicios` do json-server.
class ExerciseApiService {
  /// Base URL da API.
  /// - Android emulator: `http://10.0.2.2:3000`
  /// - iOS simulator / desktop: `http://localhost:3000`
  static final String _baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:3000'
      : 'http://localhost:3000';

  final http.Client _client = http.Client();

  static const _headers = {'Content-Type': 'application/json'};

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// Retorna todos os exercicios da API.
  Future<List<Exercise>> getAll() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/exercicios'),
      headers: _headers,
    );
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Exercise.fromJson(json)).toList();
  }

  /// Retorna exercicio por ID.
  Future<Exercise?> getById(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/exercicios/$id'),
        headers: _headers,
      );
      if (response.statusCode == 404) return null;
      return Exercise.fromJson(json.decode(response.body));
    } catch (_) {
      return null;
    }
  }

  /// Adiciona um exercicio.
  Future<Exercise> add(Exercise exercise) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/exercicios'),
      headers: _headers,
      body: json.encode(exercise.toJson()),
    );
    return Exercise.fromJson(json.decode(response.body));
  }

  /// Atualiza um exercicio existente (PUT).
  Future<Exercise> update(Exercise exercise) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/exercicios/${exercise.id}'),
      headers: _headers,
      body: json.encode(exercise.toJson()),
    );
    return Exercise.fromJson(json.decode(response.body));
  }

  /// Remove exercicio por id.
  Future<bool> remove(String id) async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/exercicios/$id'),
      headers: _headers,
    );
    return response.statusCode == 200;
  }

  /// Marca/desmarca exercicio como completo via PATCH.
  Future<void> toggleComplete(String id) async {
    final exercise = await getById(id);
    if (exercise == null) return;

    await _client.patch(
      Uri.parse('$_baseUrl/exercicios/$id'),
      headers: _headers,
      body: json.encode({'isCompleted': !exercise.isCompleted}),
    );
  }

  // ---------------------------------------------------------------------------
  // Consultas derivadas (calculadas a partir dos dados da API)
  // ---------------------------------------------------------------------------

  /// Retorna exercicios filtrados por categoria.
  Future<List<Exercise>> getByCategory(String category) async {
    final all = await getAll();
    return all.where((e) => e.category == category).toList();
  }

  /// Retorna categorias unicas.
  Future<List<String>> getCategories() async {
    final all = await getAll();
    return all.map((e) => e.category).toSet().toList()..sort();
  }

  /// Total de exercicios.
  Future<int> get totalExercises async => (await getAll()).length;

  /// Total de exercicios completos.
  Future<int> get completedExercises async =>
      (await getAll()).where((e) => e.isCompleted).length;

  /// Retorna estatisticas do treino.
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

  /// Libera recursos do client HTTP.
  void dispose() {
    _client.close();
  }
}
