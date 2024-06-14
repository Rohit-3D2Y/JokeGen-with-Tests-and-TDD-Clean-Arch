// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:joke_gen_1/core/injection_container.dart'; // Adjust import as per your project structure
import 'package:joke_gen_1/features/jokes/domain/repos_2/joke_repository.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_bloc.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_event.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_state.dart';

import '../../domain/usecases/get_random_joke.dart';

class JokePage extends StatefulWidget {
  final JokeRepository jokeRepository;

  JokePage({required this.jokeRepository});

  @override
  _JokePageState createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  late JokeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = JokeBloc(repository: widget.jokeRepository, getJoke: sl<GetJoke>());
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Joke Generator'),
      ),
      body: Center(
        child: StreamBuilder<JokeState>(
          stream: _bloc.state,
          initialData: JokeEmpty(),
          builder: (context, snapshot) {
            if (snapshot.data is JokeEmpty) {
              return Text('Press the button to get a joke');
            } else if (snapshot.data is JokeLoading) {
              return CircularProgressIndicator();
            } else if (snapshot.data is JokeLoaded) {
              final joke = (snapshot.data as JokeLoaded).joke;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      joke.setup,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    joke.punchline,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            } else if (snapshot.data is JokeError) {
              return Text(
                (snapshot.data as JokeError).message,
                style: TextStyle(color: Colors.red),
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bloc.eventSink.add(GetJokeEvent());
        },
        tooltip: 'Get Joke',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
