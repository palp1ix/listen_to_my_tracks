import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/core/widgets/track_list_tile.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/features/search/bloc/search_bloc.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key, required this.query});
  // The search query to look for tracks.
  final String query;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final SearchBloc _searchBloc;
  late final TextEditingController _controller;

  @override
  void initState() {
    // Initialize the SearchBloc with the MusicRepositoryImpl.
    _searchBloc = context.read<SearchBloc>();
    // Trigger the search when the screen is initialized.
    _searchBloc.add(SearchRequested(widget.query));
    // Initialize the text controller with the initial query.
    _controller = TextEditingController(text: widget.query);
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
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _controller,
                style: TextStyle(color: theme.hintColor),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear_rounded, color: theme.hintColor),
                    onPressed: () {
                      // TODO: Should return to previous page
                    },
                  ),
                ),
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