// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:joke_gen_1/core/injection_container.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_bloc.dart';
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
      home: BlocProvider(
        create: (context) => JokeBloc(
          repository: sl(),
          getJoke: sl(),
        ),
        child: JokePage(),
      ),
    );
  }
}
