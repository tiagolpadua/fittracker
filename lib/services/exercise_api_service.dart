import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fittracker/models/exercise.dart';
import 'package:http/http.dart' as http;

/// Excecao customizada para erros de API
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Servico para consumo da API de exercicios
/// Demonstra: async/await, tratamento de erros HTTP, JSON parsing
class ExerciseApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  ExerciseApiService({http.Client? client}) : _client = client ?? http.Client();

  /// GET /exercicios - Busca todos os exercicios
  Future<List<Exercise>> getAll() async {
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/exercicios'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Exercise.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Erro ao buscar exercicios: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException('Sem conexao com a internet. Verifique sua rede.');
    } on TimeoutException {
      throw ApiException('Servidor demorou para responder. Tente novamente.');
    } on FormatException {
      throw ApiException('Erro ao processar dados do servidor.');
    }
  }

  /// GET /exercicios/:id - Busca um exercicio por ID
  Future<Exercise> getById(String id) async {
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl/exercicios/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return Exercise.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw ApiException('Exercicio nao encontrado', statusCode: 404);
      } else {
        throw ApiException(
          'Erro ao buscar exercicio: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException('Sem conexao com a internet.');
    } on TimeoutException {
      throw ApiException('Timeout ao buscar exercicio.');
    }
  }

  /// POST /exercicios - Cria um novo exercicio
  Future<Exercise> create(Exercise exercise) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/exercicios'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(exercise.toJson()),
          )
          .timeout(_timeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Exercise.fromJson(json.decode(response.body));
      } else {
        throw ApiException(
          'Erro ao criar exercicio: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException('Sem conexao com a internet.');
    } on TimeoutException {
      throw ApiException('Timeout ao criar exercicio.');
    }
  }

  /// PUT /exercicios/:id - Atualiza um exercicio
  Future<Exercise> update(Exercise exercise) async {
    if (exercise.id == null) {
      throw ApiException('ID do exercicio e obrigatorio para atualizar');
    }

    try {
      final response = await _client
          .put(
            Uri.parse('$_baseUrl/exercicios/${exercise.id}'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(exercise.toJson()),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return Exercise.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw ApiException('Exercicio nao encontrado', statusCode: 404);
      } else {
        throw ApiException(
          'Erro ao atualizar exercicio: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException('Sem conexao com a internet.');
    } on TimeoutException {
      throw ApiException('Timeout ao atualizar exercicio.');
    }
  }

  /// PATCH /exercicios/:id - Atualiza parcialmente um exercicio
  Future<Exercise> patch(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _client
          .patch(
            Uri.parse('$_baseUrl/exercicios/$id'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(updates),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return Exercise.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw ApiException('Exercicio nao encontrado', statusCode: 404);
      } else {
        throw ApiException(
          'Erro ao atualizar exercicio: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException('Sem conexao com a internet.');
    } on TimeoutException {
      throw ApiException('Timeout ao atualizar exercicio.');
    }
  }

  /// DELETE /exercicios/:id - Remove um exercicio
  Future<void> delete(String id) async {
    try {
      final response = await _client
          .delete(
            Uri.parse('$_baseUrl/exercicios/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          'Erro ao remover exercicio: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException('Sem conexao com a internet.');
    } on TimeoutException {
      throw ApiException('Timeout ao remover exercicio.');
    }
  }

  /// Toggle isCompleted de um exercicio
  Future<Exercise> toggleComplete(String id, bool isCompleted) async {
    return patch(id, {'isCompleted': isCompleted});
  }

  /// Libera recursos do client HTTP
  void dispose() {
    _client.close();
  }
}
