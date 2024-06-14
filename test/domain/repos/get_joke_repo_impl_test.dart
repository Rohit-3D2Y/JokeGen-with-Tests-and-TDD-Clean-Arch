import 'package:flutter_test/flutter_test.dart';
import 'package:joke_gen_1/features/jokes/data/datasources/joke_remote_datasource.dart';
import 'package:joke_gen_1/features/jokes/data/repos/joke_repository.dart';
import 'package:joke_gen_1/features/jokes/domain/entities/jokes.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:joke_gen_1/core/errors/exceptions.dart';
import 'package:joke_gen_1/core/errors/failures.dart';
import 'package:joke_gen_1/features/jokes/data/models/joke_model.dart';

import 'get_joke_repo_impl_test.mocks.dart';

@GenerateMocks([JokeRemoteDataSource])

void main() {
  late JokeRepositoryImpl repository;
  late MockJokeRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockJokeRemoteDataSource();
    repository = JokeRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tJokeModel = JokeModel(
    setup: 'Why don\'t scientists trust atoms?',
    punchline: 'Because they make up everything!',
  );
  final Joke tJoke = tJokeModel;

  test(
      'should return remote data when the call to remote data source is successful',
      () async {
    // arrange
    when(mockRemoteDataSource.getRandomJoke()).thenAnswer((_) async => tJokeModel);
    // act
    final result = await repository.getRandomJoke();
    // assert
    verify(mockRemoteDataSource.getRandomJoke());
    expect(result, equals(Right(tJoke)));
  });

  test(
      'should return ServerFailure when the call to remote data source is unsuccessful',
      () async {
    // arrange
    when(mockRemoteDataSource.getRandomJoke()).thenThrow(ServerException());
    // act
    final result = await repository.getRandomJoke();
    // assert
    verify(mockRemoteDataSource.getRandomJoke());
    expect(result, equals(Left(ServerFailure())));
  });
}
