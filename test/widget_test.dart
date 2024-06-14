// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joke_gen_1/features/jokes/domain/entities/jokes.dart';
import 'package:joke_gen_1/features/jokes/domain/repos_2/joke_repository.dart';
import 'package:joke_gen_1/features/jokes/presentation/pages/joke_page.dart';
import 'package:mockito/mockito.dart';

// Mock JokeRepository
class MockJokeRepository extends Mock implements JokeRepository {}

void main() {
  late MockJokeRepository mockJokeRepository;

  setUp(() {
    mockJokeRepository = MockJokeRepository();
  });

  testWidgets('JokePage - Widget Test', (WidgetTester tester) async {
    // Mock data
    final mockJoke = Joke(setup: 'Why did the scarecrow win an award?', punchline: 'Because he was outstanding in his field!');

    // Build JokePage with mocked dependencies
    await tester.pumpWidget(MaterialApp(
      home: JokePage(jokeRepository: mockJokeRepository),
    ));

    // Verify initial state
    expect(find.text('Press the button to get a joke'), findsOneWidget);

    // Mock behavior when `getRandomJoke` is called
    when(mockJokeRepository.getRandomJoke()).thenAnswer((_) async => Right(mockJoke));

    // Tap on the floating action button
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify loading indicator appears
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the state to update
    await tester.pump(Duration(seconds: 1));

    // Verify joke setup and punchline are displayed
    expect(find.text(mockJoke.setup), findsOneWidget);
    expect(find.text(mockJoke.punchline), findsOneWidget);
  });
}
