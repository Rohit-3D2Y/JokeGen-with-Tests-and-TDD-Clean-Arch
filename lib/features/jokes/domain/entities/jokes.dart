// ignore_for_file: non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';

class Joke extends Equatable {
  final String setup;
  final String punchline;

  Joke({ required this.setup , required this.punchline});
  
  @override
  List<Object?> get props => [setup,punchline];
}

