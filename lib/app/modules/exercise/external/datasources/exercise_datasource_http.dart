import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../infra/datasources/exercise_datasource.dart';
import '../../infra/models/exercise_model.dart';

/// Implementacao do DataSource usando HTTP.
class ExerciseDataSourceHttp implements ExerciseDataSource {
  static const String _baseUrl = 'http://10.0.2.2:3000';

  final http.Client client;

  ExerciseDataSourceHttp(this.client);

  @override
  Future<List<ExerciseModel>> getAll() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/exercicios'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Erro HTTP: ${response.statusCode}');
    }
    final List<dynamic> data = json.decode(response.body) as List<dynamic>;
    return data
        .map((item) => ExerciseModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ExerciseModel?> getById(String id) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/exercicios/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Erro HTTP: ${response.statusCode}');
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    return ExerciseModel.fromJson(data);
  }

  @override
  Future<void> save(ExerciseModel exercise) async {
    final existing = await getById(exercise.id);
    if (existing == null) {
      final response = await client.post(
        Uri.parse('$_baseUrl/exercicios'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(exercise.toJson()),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Erro HTTP: ${response.statusCode}');
      }
      return;
    }

    final response = await client.put(
      Uri.parse('$_baseUrl/exercicios/${exercise.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(exercise.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro HTTP: ${response.statusCode}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/exercicios/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro HTTP: ${response.statusCode}');
    }
  }
}
