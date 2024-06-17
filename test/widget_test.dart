import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joke_gen_1/features/jokes/domain/entities/jokes.dart';
import 'package:joke_gen_1/features/jokes/domain/usecases/get_random_joke.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_bloc.dart';
import 'package:joke_gen_1/features/jokes/presentation/bloc/joke_state.dart';
import 'package:joke_gen_1/features/jokes/presentation/pages/joke_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([JokeBloc, GetJoke])
void main() {
  late MockJokeBloc mockJokeBloc;
  late MockGetJoke mockGetRandomJoke;

  setUp(() {
    mockJokeBloc = MockJokeBloc();
    mockGetRandomJoke = MockGetJoke();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<JokeBloc>(
        create: (context) => mockJokeBloc,
        child: child,
      ),
    );
  }

  testWidgets('JokePage displays a joke when loaded', (WidgetTester tester) async {
    final joke = Joke(setup: 'Why did the scarecrow win an award?', punchline: 'Because he was outstanding in his field!');

    // Stub the behavior of GetRandomJoke use case
    when(mockGetRandomJoke(any)).thenAnswer((_) async => Right(joke));

    // Stub the stream property of mockJokeBloc to return a stream of states
    when(mockJokeBloc.stream).thenAnswer((_) => Stream.fromIterable([
      JokeEmpty(),
      JokeLoading(),
      JokeLoaded(joke: joke),
    ]));

    // Pump the widget wrapped with MaterialApp and BlocProvider
    await tester.pumpWidget(makeTestableWidget(JokePage()));

    // Verify initial state
    expect(find.text('Press the button to get a joke'), findsOneWidget);

    // Tap the button to trigger event
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the widget to rebuild with loaded state
    await tester.pump();

    // Verify loaded joke is displayed
    expect(find.text(joke.setup), findsOneWidget);
    expect(find.text(joke.punchline), findsOneWidget);
  });
}
