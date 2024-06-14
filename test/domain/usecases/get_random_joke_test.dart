import 'package:flutter_test/flutter_test.dart';
import 'package:joke_gen_1/core/usecases/usecase.dart';
import 'package:joke_gen_1/features/jokes/domain/entities/jokes.dart';
import 'package:joke_gen_1/features/jokes/domain/repos_2/joke_repository.dart';
import 'package:joke_gen_1/features/jokes/domain/usecases/get_random_joke.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'get_random_joke_test.mocks.dart';


@GenerateMocks([JokeRepository])
void main() {
  late MockJokeRepository mockJokeRepository;
  late GetJoke usecase;

  setUp(() {
    mockJokeRepository = MockJokeRepository();
    usecase = GetJoke(mockJokeRepository);
  });

  final tJoke = Joke(setup: 'Why did the chicken cross the road?', punchline: 'To get to the other side!');

  test('should get joke from the repository', () async {
    // Arrange
    when(mockJokeRepository.getRandomJoke()).thenAnswer((_) async => Right(tJoke));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, Right(tJoke));
    verify(mockJokeRepository.getRandomJoke());
    verifyNoMoreInteractions(mockJokeRepository);
  });
}
