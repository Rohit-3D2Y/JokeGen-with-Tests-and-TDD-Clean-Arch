import 'dart:convert'; // Add import for json.encode and json.decode
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:joke_gen_1/features/jokes/data/datasources/joke_remote_datasource.dart';
import 'package:joke_gen_1/features/jokes/data/models/joke_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'joke_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([http.Client, JokeRemoteDataSource])
void main() {
  late JokeRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = JokeRemoteDataSourceImpl(client: mockHttpClient);
  });

  final jokeModel = JokeModel(setup: 'hello hello', punchline: 'yoo');

  test('should perform a get request and return a joke model', () async {
    // arrange
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(json.encode(jokeModel.toJson()), 200));

    // act
    final result = await dataSource.getRandomJoke();

    // assert
    expect(result, equals(jokeModel));
  });
}
