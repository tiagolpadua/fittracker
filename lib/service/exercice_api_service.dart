import 'dart:convert';

import 'package:fittracker/models/exercise.dart';
import 'package:http/http.dart' as http;

class ExerciseApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000';

  final http.Client _client = http.Client();

  Future<List<Exercise>> getAll() async {
    await Future.delayed(Duration(seconds: 5)); // Add this line
    final response = await _client.get(
      Uri.parse('$_baseUrl/exercicios'),
      headers: {'Content-Type': 'application/json'},
    );
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Exercise.fromJson(json)).toList();
  }
}
