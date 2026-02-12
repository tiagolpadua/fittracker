import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fittracker/app/modules/exercise/domain/entities/exercise.dart';
import 'package:fittracker/app/modules/exercise/domain/errors/failures.dart';
import 'package:fittracker/app/modules/exercise/domain/usecases/get_exercise_by_id.dart';

import '../../../../mocks/mock_exercise_repository.dart';

void main() {
  late GetExerciseById useCase;
  late MockExerciseRepository mockRepo;

  setUp(() {
    mockRepo = MockExerciseRepository();
    useCase = GetExerciseById(mockRepo);
  });

  test('deve retornar exercicio quando encontrado', () async {
    const exercise = Exercise(
      id: '1',
      name: 'Supino',
      sets: 4,
      reps: 12,
      category: 'Peito',
    );

    when(mockRepo.getById('1')).thenAnswer((_) async => exercise);

    final result = await useCase.call('1');

    expect(result, isNotNull);
    expect(result!.name, 'Supino');
    verify(mockRepo.getById('1')).called(1);
  });

  test('deve retornar null quando exercicio nao encontrado', () async {
    when(mockRepo.getById('999')).thenAnswer((_) async => null);

    final result = await useCase.call('999');

    expect(result, isNull);
  });

  test('deve lancar ValidationFailure quando id e vazio', () {
    expect(() => useCase.call(''), throwsA(isA<ValidationFailure>()));
    verifyNever(mockRepo.getById(''));
  });
}
