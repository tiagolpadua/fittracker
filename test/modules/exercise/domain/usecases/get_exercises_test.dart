import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fittracker/app/modules/exercise/domain/entities/exercise.dart';
import 'package:fittracker/app/modules/exercise/domain/usecases/get_exercises.dart';

import '../../../../mocks/mock_exercise_repository.dart';

void main() {
  late GetExercises useCase;
  late MockExerciseRepository mockRepository;

  setUp(() {
    mockRepository = MockExerciseRepository();
    useCase = GetExercises(mockRepository);
  });

  final exercicios = [
    const Exercise(
        id: '1', name: 'Supino Reto', sets: 4, reps: 12, category: 'Peito'),
    const Exercise(
        id: '2', name: 'Agachamento', sets: 4, reps: 10, category: 'Pernas'),
  ];

  test('deve retornar lista de exercicios do repositorio', () async {
    // Arrange
    when(mockRepository.getAll()).thenAnswer((_) async => exercicios);

    // Act
    final result = await useCase.call();

    // Assert
    expect(result, hasLength(2));
    expect(result[0].name, 'Supino Reto');
    expect(result[1].name, 'Agachamento');
    verify(mockRepository.getAll()).called(1);
  });

  test('deve retornar lista vazia quando nao ha exercicios', () async {
    when(mockRepository.getAll()).thenAnswer((_) async => []);

    final result = await useCase.call();

    expect(result, isEmpty);
    verify(mockRepository.getAll()).called(1);
  });

  test('deve propagar excecao do repositorio', () async {
    when(mockRepository.getAll()).thenThrow(Exception('Erro de rede'));

    expect(() => useCase.call(), throwsA(isA<Exception>()));
  });
}
