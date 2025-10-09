import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:listen_to_my_tracks/data/datasources/music_remote_datasource.dart';
import 'package:listen_to_my_tracks/data/datasources/search_history_local_datasource.dart';
import 'package:listen_to_my_tracks/data/repositories/music_repository_impl.dart';
import 'package:listen_to_my_tracks/data/repositories/search_history_repository_impl.dart';
import 'package:listen_to_my_tracks/domain/repositories/music_repository.dart';
import 'package:listen_to_my_tracks/domain/repositories/search_history_repository.dart';
import 'package:listen_to_my_tracks/domain/services/audio_player_service.dart';
import 'package:listen_to_my_tracks/features/artist_tracks/bloc/artist_tracks_bloc.dart';
import 'package:listen_to_my_tracks/features/details/bloc/track_player_bloc.dart';
import 'package:listen_to_my_tracks/features/home/bloc/home_bloc.dart';
import 'package:listen_to_my_tracks/features/search/bloc/search_bloc.dart';

// This is our global Service Locator.
final sl = GetIt.instance;

// This function is responsible for registering all the dependencies.
Future<void> configureDependencies() async {
  // --- External ---
  sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: 'https://api.deezer.com')),
  );

  // --- Data Sources ---
  sl
    ..registerLazySingleton<MusicRemoteDataSource>(
      () => MusicRemoteDataSourceImpl(dio: sl()),
    )
    ..registerLazySingleton<SearchHistoryLocalDataSource>(
      () => SearchHistoryLocalDataSourceImpl(),
    );

  // --- Repositories ---
  sl
    ..registerLazySingleton<MusicRepository>(
      () => MusicRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton<SearchHistoryRepository>(
      () => SearchHistoryRepositoryImpl(localDataSource: sl()),
    );

  // --- Services ---
  sl.registerLazySingleton<AudioPlayerService>(() => AudioPlayerService());

  // --- BLoCs ---
  sl
    ..registerFactory<HomeBloc>(() => HomeBloc(sl()))
    ..registerFactory<SearchBloc>(() => SearchBloc(sl(), sl()))
    ..registerFactory<TrackPlayerBloc>(
      () => TrackPlayerBloc(audioPlayerService: sl()),
    )
    ..registerFactory<ArtistTracksBloc>(() => ArtistTracksBloc(sl()));
}
