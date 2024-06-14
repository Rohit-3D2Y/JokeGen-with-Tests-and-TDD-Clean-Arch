import 'package:equatable/equatable.dart';

abstract class JokeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetJokeEvent extends JokeEvent {}
