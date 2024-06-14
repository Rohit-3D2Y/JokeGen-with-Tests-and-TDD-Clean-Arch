import 'dart:async';
import 'package:joke_gen_1/core/errors/failures.dart';
import 'package:joke_gen_1/features/jokes/domain/usecases/get_random_joke.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repos_2/joke_repository.dart';
import 'joke_event.dart';
import 'joke_state.dart';

class JokeBloc {
  final JokeRepository repository;
  final GetJoke getJoke;

  JokeBloc({required this.repository, required this.getJoke}) {
    _eventController.stream.listen(_mapEventToState);
  }

  final _stateController = StreamController<JokeState>();
  Stream<JokeState> get state => _stateController.stream;
  StreamSink<JokeState> get _inState => _stateController.sink;

  final _eventController = StreamController<JokeEvent>();
  Sink<JokeEvent> get eventSink => _eventController.sink;

  void _mapEventToState(JokeEvent event) async {
    if (event is GetJokeEvent) {
      _inState.add(JokeLoading());
      final eitherFailureOrJoke = await getJoke(NoParams());
      _inState.add(
        eitherFailureOrJoke.fold(
          (failure) => JokeError(message: _mapFailureToMessage(failure)),
          (joke) => JokeLoaded(joke: joke),
        ),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    return 'An error occurred';
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
