import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fittracker/app/modules/exercise/domain/entities/exercise.dart';
import 'package:fittracker/app/modules/exercise/domain/errors/failures.dart';
import 'package:fittracker/app/modules/exercise/domain/usecases/add_exercise.dart';

import '../../../../mocks/mock_exercise_repository.dart';

void main() {
  late AddExercise useCase;
  late MockExerciseRepository mockRepo;

  setUp(() {
    mockRepo = MockExerciseRepository();
    useCase = AddExercise(mockRepo);
  });

  const exerciseValido = Exercise(
    id: '1',
    name: 'Supino',
    sets: 4,
    reps: 12,
    category: 'Peito',
  );

  test('deve adicionar exercicio valido', () async {
    when(mockRepo.add(exerciseValido)).thenAnswer((_) async {});

    await useCase.call(exerciseValido);
    verify(mockRepo.add(exerciseValido)).called(1);
  });

  test('deve lancar ValidationFailure quando nome e vazio', () {
    const exercise = Exercise(
      id: '1',
      name: '',
      sets: 4,
      reps: 12,
      category: 'Peito',
    );

    expect(
        () => useCase.call(exercise), throwsA(isA<ValidationFailure>()));
    verifyNever(mockRepo.add(exercise));
  });

  test('deve lancar ValidationFailure quando sets e zero', () {
    const exercise = Exercise(
      id: '1',
      name: 'Supino',
      sets: 0,
      reps: 12,
      category: 'Peito',
    );

    expect(
        () => useCase.call(exercise), throwsA(isA<ValidationFailure>()));
    verifyNever(mockRepo.add(exercise));
  });

  test('deve lancar ValidationFailure quando reps e negativo', () {
    const exercise = Exercise(
      id: '1',
      name: 'Supino',
      sets: 4,
      reps: -1,
      category: 'Peito',
    );

    expect(
        () => useCase.call(exercise), throwsA(isA<ValidationFailure>()));
    verifyNever(mockRepo.add(exercise));
  });
}
