import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:joke_gen_1/features/jokes/data/datasources/joke_remote_datasource.dart';
import 'package:joke_gen_1/features/jokes/data/repos/joke_repository.dart';
import 'package:joke_gen_1/features/jokes/domain/usecases/get_random_joke.dart';
import 'package:joke_gen_1/features/jokes/domain/repos_2/joke_repository.dart';

import '../features/jokes/presentation/bloc/joke_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register Bloc
  sl.registerFactory(() => JokeBloc(
        repository: sl(),
        getJoke: sl(),
      ));

  // Register UseCase
  sl.registerLazySingleton(() => GetJoke(sl()));

  // Register Repository
  sl.registerLazySingleton<JokeRepository>(() => JokeRepositoryImpl(remoteDataSource: sl()));

  // Register DataSource
  sl.registerLazySingleton<JokeRemoteDataSource>(() => JokeRemoteDataSourceImpl(client: sl()));

  // Register External
  sl.registerLazySingleton(() => http.Client());
}
