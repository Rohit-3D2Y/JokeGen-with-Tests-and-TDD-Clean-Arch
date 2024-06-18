// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:joke_gen_1/features/jokes/domain/entities/jokes.dart';
import 'package:joke_gen_1/features/jokes/domain/repos_2/joke_repository.dart';
import 'package:joke_gen_1/features/jokes/domain/usecases/get_random_joke.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_event.dart';
import 'package:mockito/annotations.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_bloc.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_state.dart';
import 'package:joke_gen_1/features/jokes/presentation/pages/joke_page.dart';

import 'presentation/bloc_test.mocks.dart';

class MockJokeBloc extends MockBloc<JokeEvent, JokeState> implements JokeBloc {}

@GenerateMocks([JokeRepository, GetJoke])
void main() {
  late MockGetJoke mockGetJoke;
  late MockJokeRepository mockJokeRepository;
  late MockJokeBloc mockJokeBloc;

  setUp(() {
    GetIt.I.reset();
    mockGetJoke = MockGetJoke();
    mockJokeRepository = MockJokeRepository();
    mockJokeBloc = MockJokeBloc();
    GetIt.I.registerSingleton<JokeRepository>(
      mockJokeRepository,
    );
  });

  testWidgets('JokePage renders correctly in initial state',
      (WidgetTester tester) async {
    // Mock the initial state of the JokeBloc
    // when(mockJokeBloc.state).thenReturn(JokeEmpty());
    final StreamController<JokeState> controller =
        StreamController<JokeState>.broadcast();

    whenListen(
      mockJokeBloc,
      controller.stream,
      initialState: JokeEmpty(),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<JokeBloc>(
            create: (context) => mockJokeBloc,
          ),
        ],
        child: MaterialApp(
          home: JokePage(),
        ),
      ),
    );
    await tester.pump();

    // Check if the initial text is displayed
    expect(find.text('Press the button to get a joke'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('An error occurred'), findsNothing);
    expect(find.text('setup'), findsNothing);
    expect(find.text('punchline'), findsNothing);
    controller.close();

    // controller.add(JokeLoading());
    // await tester.pump();
    //     expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('JokePage renders correctly in Loading state',
      (WidgetTester tester) async {
    // Mock the initial state of the JokeBloc
    // when(mockJokeBloc.state).thenReturn(JokeEmpty());
    final StreamController<JokeState> controller =
        StreamController<JokeState>.broadcast();

    whenListen(
      mockJokeBloc,
      controller.stream,
      initialState: JokeLoading(),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<JokeBloc>(
            create: (context) => mockJokeBloc,
          ),
        ],
        child: MaterialApp(
          home: JokePage(),
        ),
      ),
    );
    await tester.pump();

    // Check if the initial text is displayed
    expect(find.text('Press the button to get a joke'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('An error occurred'), findsNothing);
    expect(find.text('setup'), findsNothing);
    expect(find.text('punchline'), findsNothing);
  });

  testWidgets('JokePage renders correctly in Loaded state',
      (WidgetTester tester) async {
    // Mock the initial state of the JokeBloc
    // when(mockJokeBloc.state).thenReturn(JokeEmpty());
    final StreamController<JokeState> controller =
        StreamController<JokeState>.broadcast();

    final Joke joke = Joke(setup: 'setup', punchline: 'punchline');

    whenListen(
      mockJokeBloc,
      controller.stream,
      initialState:
          JokeLoaded(joke: Joke(setup: 'setup', punchline: 'punchline')),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<JokeBloc>(
            create: (context) => mockJokeBloc,
          ),
        ],
        child: MaterialApp(
          home: JokePage(),
        ),
      ),
    );
    await tester.pump();

    // Check if the initial text is displayed
    expect(find.text('Press the button to get a joke'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('An error occurred'), findsNothing);
    expect(find.text('setup'), findsOneWidget);
    expect(find.text('punchline'), findsOneWidget);
  });

  testWidgets('JokePage renders correctly in Error state',
      (WidgetTester tester) async {
    // Mock the initial state of the JokeBloc
    // when(mockJokeBloc.state).thenReturn(JokeEmpty());
    final StreamController<JokeState> controller =
        StreamController<JokeState>.broadcast();

    whenListen(
      mockJokeBloc,
      controller.stream,
      initialState: JokeError(message: 'An error occurred'),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<JokeBloc>(
            create: (context) => mockJokeBloc,
          ),
        ],
        child: MaterialApp(
          home: JokePage(),
        ),
      ),
    );
    await tester.pump();

    // Check if the initial text is displayed
    expect(find.text('Press the button to get a joke'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('An error occurred'), findsOneWidget);
    expect(find.text('setup'), findsNothing);
    expect(find.text('punchline'), findsNothing);

    controller.close();
  });
}
