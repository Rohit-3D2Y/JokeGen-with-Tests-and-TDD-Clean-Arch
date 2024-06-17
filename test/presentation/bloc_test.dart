import 'package:flutter_test/flutter_test.dart';
import 'package:joke_gen_1/core/errors/failures.dart';
import 'package:joke_gen_1/core/usecases/usecase.dart';
import 'package:joke_gen_1/features/jokes/domain/entities/jokes.dart';
import 'package:joke_gen_1/features/jokes/domain/repos_2/joke_repository.dart';
import 'package:joke_gen_1/features/jokes/domain/usecases/get_random_joke.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_bloc.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_event.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';

import 'bloc_test.mocks.dart';

@GenerateMocks([GetJoke, JokeRepository])
void main() {
  late JokeBloc bloc;
  late MockGetJoke mockGetJoke;
  late MockJokeRepository mockRepository;

  setUp(() {
    mockGetJoke = MockGetJoke();
    mockRepository = MockJokeRepository();
    bloc = JokeBloc(repository: mockRepository, getJoke: mockGetJoke);
  });

  final tJoke = Joke(setup: 'Why don\'t scientists trust atoms?', punchline: 'Because they make up everything!');

  test('initial state should be JokeEmpty', () {
    expect(bloc.state, equals(JokeEmpty()));
  });

  blocTest<JokeBloc, JokeState>(
    'should get data from the use case',
    build: () {
      when(mockGetJoke(any)).thenAnswer((_) async => Right(tJoke));
      return bloc;
    },
    act: (bloc) => bloc.add(GetJokeEvent()),
    expect: () => [
      JokeLoading(),
      JokeLoaded(joke: tJoke),
    ],
    verify: (_) async {
      verify(mockGetJoke(NoParams()));
    },
  );

  blocTest<JokeBloc, JokeState>(
    'should emit [JokeLoading, JokeError] when getting data fails',
    build: () {
      when(mockGetJoke(any)).thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(GetJokeEvent()),
    expect: () => [
      JokeLoading(),
      JokeError(message: 'An error occurred'),
    ],
  );
}
