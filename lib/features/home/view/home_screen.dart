import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart'; // Assuming you have this entity
import 'package:listen_to_my_tracks/features/home/bloc/home_bloc.dart';
import '../widgets/widgets.dart';

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
    _homeBloc = context.read<HomeBloc>();
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
class _HomeLoadedView extends StatefulWidget {
  const _HomeLoadedView({required this.chart});

  final List<TrackEntity> chart;

  @override
  State<_HomeLoadedView> createState() => _HomeLoadedViewState();
}

class _HomeLoadedViewState extends State<_HomeLoadedView> {
  late final HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = context.read<HomeBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        // Using Slivers for a more performant and flexible scrollable layout.
        slivers: [
          const SliverToBoxAdapter(child: WelcomeHeader()),
          const SliverToBoxAdapter(child: SearchActionCard()),
          const SliverToBoxAdapter(child: SectionHeader(title: 'Top Charts')),

          widget.chart.isNotEmpty
              ? SliverList.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final track = widget.chart[index];
                    return ChartTrackListItem(track: track, rank: index + 1);
                  },
                )
              : SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'No tracks available in your region. Try to use VPN',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              _homeBloc.add(HomeScreenStarted());
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
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
