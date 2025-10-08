import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/app/router/router.gr.dart';
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
    _searchBloc.add(HistoryRequested());
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
        child: Column(
          children: [
            CustomSearchBar(
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: (query) {
                _focusNode.unfocus();
                _searchBloc.add(SearchRequested(query));
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              // The BlocListener will handle UI side-effects, like updating the controller,
              // without triggering a rebuild of the entire screen.
              child: BlocListener<SearchBloc, SearchState>(
                bloc: _searchBloc,
                // We use listenWhen to ensure this logic only runs when a search starts.
                // This prevents the text field from being updated on every state change.
                listenWhen: (previous, current) =>
                    previous is! SearchLoading && current is SearchLoading,
                listener: (context, state) {
                  if (state is SearchLoading) {
                    // Update controller's text if it doesn't match the query.
                    if (_controller.text != state.query) {
                      _controller.text = state.query;
                    }
                  }
                },
                // The body now only cares about building the UI based on the state.
                child: _SearchResultsBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultsBody extends StatelessWidget {
  // We can remove the searchBloc property, as we can access it via context.
  const _SearchResultsBody();

  @override
  Widget build(BuildContext context) {
    // Access the BLoC from the context, which is cleaner.
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return switch (state) {
          SearchInitial(
            :final history,
          ) => // Use pattern matching for cleaner code
            history.isEmpty
                ? const _InfoView(
                    icon: Icons.search_rounded,
                    message: 'Please enter a search query.',
                  )
                // We no longer pass the controller here.
                : _SearchHistoryView(history),
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

class _SearchHistoryView extends StatelessWidget {
  const _SearchHistoryView(this.history);

  final List<String> history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final term = history[index];
        return ListTile(
          leading: Icon(
            Icons.history_rounded,
            color: theme.colorScheme.onSurface,
          ),
          title: Text(term),
          onTap: () {
            // Trigger a search when a history item is tapped.
            context.read<SearchBloc>().add(SearchRequested(term));
          },
        );
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
          onTap: () {
            // Navigate to track details on tap.
            context.router.push(TrackDetailsRoute(track: track));
          },
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
              fontWeight: FontWeight.bold,
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
