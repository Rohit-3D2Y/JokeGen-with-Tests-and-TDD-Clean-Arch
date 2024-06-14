import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:joke_gen_1/features/jokes/data/datasources/joke_remote_datasource.dart';
import 'package:joke_gen_1/features/jokes/data/repos/joke_repository.dart';
import 'package:joke_gen_1/features/jokes/domain/repos_2/joke_repository.dart';
import 'package:joke_gen_1/features/jokes/domain/usecases/get_random_joke.dart';

import '../features/jokes/presentation/bloc/joke_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => JokeBloc(repository: sl(), getJoke: sl()));
  sl.registerLazySingleton(() => GetJoke(sl()));
  sl.registerLazySingleton<JokeRepository>(() => JokeRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<JokeRemoteDataSource>(() => JokeRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton(() => http.Client());
}
