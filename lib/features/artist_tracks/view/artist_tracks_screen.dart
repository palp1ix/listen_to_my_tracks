import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/app/resources/colors.dart';
import 'package:listen_to_my_tracks/app/router/router.gr.dart';
import 'package:listen_to_my_tracks/core/widgets/track_list_tile.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/features/artist_tracks/bloc/artist_tracks_bloc.dart';

@RoutePage()
class ArtistTracksScreen extends StatefulWidget {
  const ArtistTracksScreen({super.key, required this.artist});

  final ArtistEntity artist;

  @override
  State<ArtistTracksScreen> createState() => _ArtistTracksScreenState();
}

class _ArtistTracksScreenState extends State<ArtistTracksScreen> {
  late final ArtistTracksBloc _artistTracksBloc;

  @override
  void initState() {
    _artistTracksBloc = context.read<ArtistTracksBloc>();
    _artistTracksBloc.add(LoadArtistTracks(widget.artist.id));
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.artist.name)),
      body: BlocBuilder<ArtistTracksBloc, ArtistTracksState>(
        bloc: _artistTracksBloc,
        builder: (context, state) {
          return switch (state) {
            ArtistTracksInitial() || ArtistTracksLoading() => const _LoadingView(),
            ArtistTracksLoaded(:final tracks) => _LoadedTracksView(tracklist: tracks),
            ArtistTracksError(:final message) => _ErrorView(message),
          };
        },
        ),
    );
  }
}


// A dedicated widget for the loaded state, returning a ListView.
class _LoadedTracksView extends StatelessWidget {
  const _LoadedTracksView({required this.tracklist});

  final List<TrackEntity> tracklist;

  @override
  Widget build(BuildContext context) {
    if (tracklist.isEmpty) {
      return const _ErrorView(
        'No availible tracks in the chart. Try to use VPN',
      );
    }

    return ListView.builder(
      itemCount: tracklist.length, 
      itemBuilder: (context, index) {
        final track = tracklist[index];
        return TrackListTile(trackTitle: track.title, imageUrl: track.album.coverUrl, artist: track.artist.name, onTap: () {
          context.router.push(TrackDetailsRoute(track: track));
        },);
      },
    );
  }
}


// A widget to show when the chart is empty.
class _ErrorView extends StatelessWidget {
  const _ErrorView(this.errorMessage);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
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
    );
  }
}

// A simple widget to show a loading indicator, adapted for a Sliver.
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive(),
    );
  }
}
