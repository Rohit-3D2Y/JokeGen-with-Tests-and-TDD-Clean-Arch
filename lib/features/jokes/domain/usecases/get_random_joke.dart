import 'package:dartz/dartz.dart';
import 'package:joke_gen_1/core/errors/failures.dart';
import 'package:joke_gen_1/core/usecases/usecase.dart';
import '../entities/jokes.dart';
import '../repos_2/joke_repository.dart';

class GetJoke implements Usecase<Joke, NoParams> {
  final JokeRepository repository;

  GetJoke(this.repository);

  @override
  Future<Either<Failure, Joke>> call(NoParams params) {
    return repository.getRandomJoke();
  }
}
