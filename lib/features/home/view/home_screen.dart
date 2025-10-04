import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/core/widgets/track_list_tile.dart';
import 'package:listen_to_my_tracks/data/datasources/music_remote_datasource.dart';
import 'package:listen_to_my_tracks/data/repositories/music_repository_impl.dart';
import 'package:listen_to_my_tracks/features/home/bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = HomeBloc(
      MusicRepositoryImpl(
        remoteDataSource: MusicRemoteDataSourceImpl(
          dio: Dio(BaseOptions(baseUrl: 'https://api.deezer.com')),
        ),
      ),
    );
    _homeBloc.add(const HomeScreenStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder(
        bloc: _homeBloc,
        builder: (context, state) {
          switch (state) {
            case HomeInitial():
              return const Center(child: Text('Initial State'));
            case HomeDataLoading():
              return const Center(child: CircularProgressIndicator());
            case HomeDataLoaded(:final chart):
              return ListView.builder(
                itemCount: chart.length,
                itemBuilder: (context, index) {
                  final track = chart[index];
                  return TrackListTile(
                    imageUrl: track.album.coverUrl,
                    trackTitle: track.title,
                    artist: track.artist.name,
                  );
                },
              );
            case HomeDataError(:final message):
              return Center(child: Text('Error: $message'));
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
