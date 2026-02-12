import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fittracker/app/modules/exercise/domain/errors/failures.dart';
import 'package:fittracker/app/modules/exercise/domain/usecases/remove_exercise.dart';

import '../../../../mocks/mock_exercise_repository.dart';

void main() {
  late RemoveExercise useCase;
  late MockExerciseRepository mockRepo;

  setUp(() {
    mockRepo = MockExerciseRepository();
    useCase = RemoveExercise(mockRepo);
  });

  test('deve remover exercicio com id valido', () async {
    when(mockRepo.remove('1')).thenAnswer((_) async {});

    await useCase.call('1');

    verify(mockRepo.remove('1')).called(1);
  });

  test('deve lancar ValidationFailure quando id e vazio', () {
    expect(
        () => useCase.call(''), throwsA(isA<ValidationFailure>()));
    verifyNever(mockRepo.remove(''));
  });

  test('deve propagar excecao do repositorio', () async {
    when(mockRepo.remove('1')).thenThrow(Exception('Erro'));

    expect(() => useCase.call('1'), throwsA(isA<Exception>()));
  });
}
