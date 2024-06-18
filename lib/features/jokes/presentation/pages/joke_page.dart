// joke_page.dart
// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_bloc.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_event.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_state.dart';

class JokePage extends StatefulWidget {
  @override
  State<JokePage> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke Generator'),
      ),
      body: BlocBuilder<JokeBloc, JokeState>(
        builder: (context, state) {
          if (state is JokeEmpty) {
            return Text('Press the button to get a joke');
          } else if (state is JokeLoading) {
            return CircularProgressIndicator();
          } else if (state is JokeLoaded) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.joke.setup, style: TextStyle(fontSize: 24)),
                  SizedBox(height: 10),
                  Text(state.joke.punchline, style: TextStyle(fontSize: 24)),
                ],
              ),
            );
          } else if (state is JokeError) {
            return Text(state.message, style: TextStyle(color: Colors.red));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<JokeBloc>().add(GetJokeEvent());
        },
        child: Icon(Icons.cloud_circle),
      ),
    );
  }
}