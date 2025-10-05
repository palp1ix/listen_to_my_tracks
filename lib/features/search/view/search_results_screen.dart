import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/core/widgets/track_list_tile.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/features/search/bloc/search_bloc.dart';
import 'package:listen_to_my_tracks/features/search/widgets/search_bar.dart';

@RoutePage()
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  // BLoC and controllers are state, so they remain in the StatefulWidget.
  late final SearchBloc _searchBloc;
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // DI logic is left as is, as requested.
    _searchBloc = context.read<SearchBloc>();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // Auto-focus the search field when the screen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchBloc.add(SearchCleared());
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Using a Column to structure the main sections of the screen:
        // the search bar and the results body.
        child: Column(
          children: [
            CustomSearchBar(
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: (query) {
                // Hide keyboard on submit
                _focusNode.unfocus();
                _searchBloc.add(SearchRequested(query));
              },
            ),
            const SizedBox(height: 10),
            // The Expanded widget ensures the results body takes up
            // all available vertical space.
            Expanded(child: _SearchResultsBody(searchBloc: _searchBloc)),
          ],
        ),
      ),
    );
  }
}

// This widget handles the presentation logic based on the SearchBloc's state.
class _SearchResultsBody extends StatelessWidget {
  const _SearchResultsBody({required this.searchBloc});

  final SearchBloc searchBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        return switch (state) {
          SearchInitial() => const _InfoView(
            icon: Icons.search,
            message: 'Please enter a search query.',
          ),
          SearchLoading() => const Center(child: CircularProgressIndicator()),
          SearchFailure(:final message) => _ErrorView(message: message),
          SearchSuccess(:final results) =>
            results.isEmpty
                ? const _InfoView(
                    icon: Icons.search_off,
                    message: 'No results found.',
                  )
                : _ResultsListView(results: results),
        };
      },
    );
  }
}

// A list to display the search results.
class _ResultsListView extends StatelessWidget {
  const _ResultsListView({required this.results});

  final List<TrackEntity> results;

  @override
  Widget build(BuildContext context) {
    // Using a fade-in effect can make the appearance of results feel smoother.
    return ListView.builder(
      // Helps with performance on long lists.
      addAutomaticKeepAlives: true,
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
  }
}

// A reusable widget for displaying centered information (e.g., initial, no results).
class _InfoView extends StatelessWidget {
  const _InfoView({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// A widget for displaying an error message, consistent with HomeScreen.
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $message', textAlign: TextAlign.center),
            // TODO: Implement retry logic. It would require storing the last
            // searched query to dispatch the event again.
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                /* Retry logic here */
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
