import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:joke_gen_1/features/jokes/data/models/joke_model.dart';
import 'package:joke_gen_1/core/errors/exceptions.dart';

abstract class JokeRemoteDataSource {
  Future<JokeModel> getRandomJoke();
}

class JokeRemoteDataSourceImpl implements JokeRemoteDataSource {
  final http.Client client;

  JokeRemoteDataSourceImpl({required this.client});

  @override
  Future<JokeModel> getRandomJoke() async {
    final response = await client.get(
      Uri.parse('https://official-joke-api.appspot.com/random_joke'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return JokeModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
