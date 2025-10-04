import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/core/widgets/track_list_tile.dart';
import 'package:listen_to_my_tracks/data/datasources/music_remote_datasource.dart';
import 'package:listen_to_my_tracks/data/repositories/music_repository_impl.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart'; // Assuming you have this entity
import 'package:listen_to_my_tracks/features/home/bloc/home_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // BLoC initialization is left as is, as requested.
  // In a real app, this would be provided by a dependency injection system.
  late final HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(
      MusicRepositoryImpl(
        remoteDataSource: MusicRemoteDataSourceImpl(
          dio: Dio(BaseOptions(baseUrl: 'https://api.deezer.com')),
        ),
      ),
    );
    _homeBloc.add(const HomeScreenStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: _homeBloc,
        builder: (context, state) {
          return switch (state) {
            // It's a good UX practice to show a loader for the initial state too.
            HomeInitial() || HomeDataLoading() => const _LoadingView(),
            HomeDataLoaded(:final chart) => _HomeLoadedView(chart: chart),
            HomeDataError(:final message) => _ErrorView(message: message),
          };
        },
      ),
    );
  }
}

// A dedicated widget for the loaded state.
// This keeps the main build method clean and focused on state management logic.
class _HomeLoadedView extends StatelessWidget {
  const _HomeLoadedView({required this.chart});

  final List<TrackEntity> chart;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        // Using Slivers for a more performant and flexible scrollable layout.
        slivers: [
          const SliverToBoxAdapter(child: _WelcomeHeader()),
          const SliverToBoxAdapter(child: _SearchActionCard()),
          const SliverToBoxAdapter(child: _SectionHeader(title: 'Top Charts')),

          SliverList.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              final track = chart[index];
              return _ChartTrackListItem(track: track, rank: index + 1);
            },
          ),
        ],
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        'Welcome!',
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// A non-functional search card to serve as a UI entry point for search.
class _SearchActionCard extends StatelessWidget {
  const _SearchActionCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        // InkWell provides visual feedback on tap.
        onTap: () {
          // TODO: Implement navigation to the search screen.
          // For now, it just prints to the console.
          debugPrint('Search tapped!');
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.search, color: hintColor),
              const SizedBox(width: 12.0),
              Text(
                'Search for tracks or artists...',
                style: TextStyle(color: hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A reusable header for sections.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

// The list item for the chart, including its rank.
class _ChartTrackListItem extends StatelessWidget {
  const _ChartTrackListItem({required this.track, required this.rank});

  final TrackEntity track;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          // A SizedBox with a fixed width ensures alignment of track tiles
          // even when the rank becomes a two-digit number.
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                '$rank',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          Expanded(
            child: TrackListTile(
              imageUrl: track.album.coverUrl,
              trackTitle: track.title,
              artist: track.artist.name,
            ),
          ),
        ],
      ),
    );
  }
}

// A simple widget to show a loading indicator.
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// A widget to display an error message.
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
            Text('An error occurred: $message', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            // A retry button is crucial for a good user experience on error screens.
            ElevatedButton(
              onPressed: () {
                // This would refetch the data.
                // context.read<HomeBloc>().add(const HomeScreenStarted());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
