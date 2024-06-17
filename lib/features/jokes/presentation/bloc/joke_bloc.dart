import 'package:bloc/bloc.dart';
import 'package:joke_gen_1/core/errors/failures.dart';
import 'package:joke_gen_1/features/jokes/domain/usecases/get_random_joke.dart';
import 'package:joke_gen_1/core/usecases/usecase.dart';
import 'package:joke_gen_1/features/jokes/domain/repos_2/joke_repository.dart';
import 'joke_event.dart';
import 'joke_state.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final JokeRepository repository;
  final GetJoke getJoke;

  JokeBloc({required this.repository, required this.getJoke}) : super(JokeEmpty()) {
    on<GetJokeEvent>(_onGetJokeEvent);
  }

  Future<void> _onGetJokeEvent(GetJokeEvent event, Emitter<JokeState> emit) async {
    emit(JokeLoading());
    final eitherFailureOrJoke = await getJoke(NoParams());
    emit(eitherFailureOrJoke.fold(
      (failure) => JokeError(message: _mapFailureToMessage(failure)),
      (joke) => JokeLoaded(joke: joke),
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    return 'An error occurred';
  }
}
