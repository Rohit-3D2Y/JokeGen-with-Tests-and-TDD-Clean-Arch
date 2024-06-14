import 'package:equatable/equatable.dart';

import '../../domain/entities/jokes.dart';

abstract class JokeState extends Equatable {
  @override
  List<Object> get props => [];
}

class JokeEmpty extends JokeState {}

class JokeLoading extends JokeState {}

class JokeLoaded extends JokeState {
  final Joke joke;

  JokeLoaded({required this.joke});

  @override
  List<Object> get props => [joke];
}

class JokeError extends JokeState {
  final String message;

  JokeError({required this.message});

  @override
  List<Object> get props => [message];
}
