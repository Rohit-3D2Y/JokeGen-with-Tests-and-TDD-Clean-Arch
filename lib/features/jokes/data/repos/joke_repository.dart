// ignore_for_file: unused_local_variable

import 'package:dartz/dartz.dart';
import 'package:joke_gen_1/core/errors/failures.dart';
import 'package:joke_gen_1/core/errors/exceptions.dart';
import 'package:joke_gen_1/features/jokes/domain/entities/jokes.dart';
import 'package:joke_gen_1/features/jokes/data/datasources/joke_remote_datasource.dart';
import 'package:joke_gen_1/features/jokes/domain/repos_2/joke_repository.dart';

class JokeRepositoryImpl implements JokeRepository {
  final JokeRemoteDataSource remoteDataSource;
  JokeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Joke>> getRandomJoke() async {
    try {
      final remoteJoke = await remoteDataSource.getRandomJoke();
      return Right(remoteJoke);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
