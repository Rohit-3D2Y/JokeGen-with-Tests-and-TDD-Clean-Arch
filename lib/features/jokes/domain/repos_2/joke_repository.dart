import 'package:dartz/dartz.dart';
import 'package:joke_gen_1/core/errors/failures.dart';
import 'package:joke_gen_1/features/jokes/domain/entities/jokes.dart';

abstract class JokeRepository {
  Future<Either<Failure, Joke>> getRandomJoke();
}
