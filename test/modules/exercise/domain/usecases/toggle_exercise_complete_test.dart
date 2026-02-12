import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fittracker/app/modules/exercise/domain/entities/exercise.dart';
import 'package:fittracker/app/modules/exercise/domain/errors/failures.dart';
import 'package:fittracker/app/modules/exercise/domain/usecases/toggle_exercise_complete.dart';

import '../../../../mocks/mock_exercise_repository.dart';

void main() {
  late ToggleExerciseComplete useCase;
  late MockExerciseRepository mockRepo;

  setUp(() {
    mockRepo = MockExerciseRepository();
    useCase = ToggleExerciseComplete(mockRepo);
  });

  test('deve marcar exercicio como completo', () async {
    const exercise = Exercise(
      id: '1',
      name: 'Supino',
      sets: 4,
      reps: 12,
      category: 'Peito',
      isCompleted: false,
    );
    final exerciseCompleted = exercise.copyWith(isCompleted: true);

    when(mockRepo.getById('1')).thenAnswer((_) async => exercise);
    when(mockRepo.update(exerciseCompleted)).thenAnswer((_) async {});

    final result = await useCase.call('1');

    expect(result.isCompleted, isTrue);
    verify(mockRepo.getById('1')).called(1);
    verify(mockRepo.update(exerciseCompleted)).called(1);
  });

  test('deve desmarcar exercicio completo', () async {
    const exercise = Exercise(
      id: '1',
      name: 'Supino',
      sets: 4,
      reps: 12,
      category: 'Peito',
      isCompleted: true,
    );
    final exerciseIncomplete = exercise.copyWith(isCompleted: false);

    when(mockRepo.getById('1')).thenAnswer((_) async => exercise);
    when(mockRepo.update(exerciseIncomplete)).thenAnswer((_) async {});

    final result = await useCase.call('1');

    expect(result.isCompleted, isFalse);
  });

  test('deve lancar ExerciseNotFoundFailure quando exercicio nao existe',
      () async {
    when(mockRepo.getById('999')).thenAnswer((_) async => null);

    expect(() => useCase.call('999'),
        throwsA(isA<ExerciseNotFoundFailure>()));
  });

  test('deve lancar ValidationFailure quando id e vazio', () {
    expect(() => useCase.call(''), throwsA(isA<ValidationFailure>()));
    verifyNever(mockRepo.getById(''));
  });
}
