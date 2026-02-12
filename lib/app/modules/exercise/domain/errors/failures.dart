/// Classe base para erros de dominio.
abstract class Failure implements Exception {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

class ValidationFailure extends Failure {
  const ValidationFailure(String field, String reason)
    : super('Campo $field invalido: $reason');
}

class ExerciseNotFoundFailure extends Failure {
  const ExerciseNotFoundFailure(String id)
    : super('Exercicio nao encontrado: $id');
}

class DataSourceFailure extends Failure {
  const DataSourceFailure(String message)
    : super('Erro ao acessar dados: $message');
}
