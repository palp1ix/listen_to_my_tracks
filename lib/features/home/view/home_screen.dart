import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/app/resources/colors.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/features/home/bloc/home_bloc.dart';
import '../widgets/widgets.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      // The main layout is now a CustomScrollView, allowing persistent headers.
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // These slivers will always be visible, regardless of the BLoC state.
            const SliverToBoxAdapter(child: WelcomeHeader()),
            const SliverToBoxAdapter(child: SearchActionCard()),
            const SliverToBoxAdapter(child: SectionHeader(title: 'Top Charts')),

            // The BlocBuilder now builds the part of the list that changes.
            BlocBuilder<HomeBloc, HomeState>(
              bloc: _homeBloc,
              builder: (context, state) {
                return switch (state) {
                  // It's a good UX practice to show a loader for the initial state too.
                  HomeInitial() ||
                  HomeDataLoading() => const _SliverLoadingView(),
                  HomeDataLoaded(:final chart) => _SliverLoadedView(
                    chart: chart,
                  ),
                  HomeDataError(:final message) => _SliverErrorView(
                    'An error occured: $message',
                  ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}

// A dedicated widget for the loaded state, returning a SliverList.
class _SliverLoadedView extends StatelessWidget {
  const _SliverLoadedView({required this.chart});

  final List<TrackEntity> chart;

  @override
  Widget build(BuildContext context) {
    if (chart.isEmpty) {
      return const _SliverErrorView(
        'No availible tracks in the chart. Try to use VPN',
      );
    }

    return SliverList.builder(
      itemCount: 7, // Assuming you only want to show the top 7
      itemBuilder: (context, index) {
        final track = chart[index];
        return ChartTrackListItem(track: track, rank: index + 1);
      },
    );
  }
}

// A widget to show when the chart is empty.
class _SliverErrorView extends StatelessWidget {
  const _SliverErrorView(this.errorMessage);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // SliverFillRemaining is used to center the content within the remaining viewport space.
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_rounded, size: 45, color: AppColors.warning),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<HomeBloc>().add(const HomeScreenStarted());
              },
              style: ButtonStyle(
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                backgroundColor: WidgetStateProperty.all(
                  AppColors.warning.withAlpha(50), // Simplified alpha
                ),
              ),
              child: Text(
                'Retry',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A simple widget to show a loading indicator, adapted for a Sliver.
class _SliverLoadingView extends StatelessWidget {
  const _SliverLoadingView();

  @override
  Widget build(BuildContext context) {
    // We wrap the indicator in SliverFillRemaining to center it.
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
