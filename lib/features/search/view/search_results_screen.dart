import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/core/widgets/track_list_tile.dart';
import 'package:listen_to_my_tracks/data/datasources/music_remote_datasource.dart';
import 'package:listen_to_my_tracks/data/repositories/music_repository_impl.dart';
import 'package:listen_to_my_tracks/features/search/bloc/search_bloc.dart';

@RoutePage()
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final SearchBloc _searchBloc;
  late final TextEditingController _controller;
  late final FocusNode _focusNode; // 1. Declare the FocusNode.

  @override
  void initState() {
    // Initialize the SearchBloc with the MusicRepositoryImpl.
    _searchBloc = SearchBloc(
      MusicRepositoryImpl(
        remoteDataSource: MusicRemoteDataSourceImpl(
          dio: Dio(BaseOptions(baseUrl: 'https://api.deezer.com')),
        ),
      ),
    );
    // Initialize the text controller.
    _controller = TextEditingController();

    // Initialize the FocusNode.
    _focusNode = FocusNode();

    // Request focus after the first frame has been rendered.
    // This ensures that the widget tree is built and ready to accept focus.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if the widget is still in the tree.
      if (mounted) {
        _focusNode.requestFocus();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _searchBloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.router.pop();
                    },
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode:
                          _focusNode, // Assign the FocusNode to the TextField.
                      onSubmitted: (value) {
                        _searchBloc.add(SearchRequested(value));
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for tracks, artists, albums...',
                      ),
                      style: TextStyle(color: theme.hintColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: BlocBuilder(
                bloc: _searchBloc,
                builder: (context, state) {
                  switch (state) {
                    case SearchInitial():
                      return const Center(
                        child: Text('Please enter a search query.'),
                      );
                    case SearchLoading():
                      return const Center(child: CircularProgressIndicator());
                    case SearchFailure(message: final message):
                      return Center(child: Text('Error: $message'));
                    case SearchSuccess(results: final results):
                      if (results.isEmpty) {
                        return const Center(child: Text('No results found.'));
                      }
                      return ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final track = results[index];
                          return TrackListTile(
                            trackTitle: track.title,
                            artist: track.artist.name,
                            imageUrl: track.album.coverUrl,
                          );
                        },
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
