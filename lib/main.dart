import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:joke_gen_1/core/injection_container.dart';
import 'package:joke_gen_1/features/jokes/data/repos/joke_repository.dart';
import 'package:joke_gen_1/features/jokes/domain/repos_2/joke_repository.dart';
import 'package:joke_gen_1/features/jokes/presentation/pages/joke_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // Initialize GetIt
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: JokePage(jokeRepository: sl<JokeRepository>()),
    );
  }
}
