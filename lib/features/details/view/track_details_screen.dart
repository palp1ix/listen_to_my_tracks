import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/features/details/bloc/track_player_bloc.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class TrackDetailsScreen extends StatelessWidget {
  const TrackDetailsScreen({super.key, required this.track});

  final TrackEntity track;

  @override
  Widget build(BuildContext context) {
    // We use BlocProvider to create and provide the TrackPlayerBloc to the widget tree.
    // The BLoC is created only once when this screen is built.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton<void>(
            onSelected: (_) {
              SharePlus.instance.share(ShareParams(uri: Uri(path: track.link)));
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<void>>[
              const PopupMenuItem<void>(
                value: null,
                child: Row(
                  children: [
                    Icon(Icons.share_outlined),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Spacer(),
            _TrackInfoSection(title: track.title, artist: track.artist.name),
            const Spacer(),
            _AlbumArtSection(coverUrl: track.album.coverUrl),
            const Spacer(),
            // The _PlayerSection is now connected to the BLoC.
            _PlayerSection(track),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

// This widget doesn't need to change as it's purely presentational.
class _TrackInfoSection extends StatelessWidget {
  const _TrackInfoSection({required this.title, required this.artist});
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    // ... no changes here
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          title,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          artist,
          style: textTheme.titleLarge?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// This widget also remains unchanged.
class _AlbumArtSection extends StatelessWidget {
  const _AlbumArtSection({required this.coverUrl});
  final String coverUrl;

  @override
  Widget build(BuildContext context) {
    // ... no changes here
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(coverUrl, fit: BoxFit.cover),
      ),
    );
  }
}

// This widget is now fully driven by the BLoC state.
// All mock data has been removed.
class _PlayerSection extends StatefulWidget {
  const _PlayerSection(this.track);

  final TrackEntity track;

  @override
  State<_PlayerSection> createState() => _PlayerSectionState();
}

class _PlayerSectionState extends State<_PlayerSection> {
  late final TrackPlayerBloc _trackBloc;

  // Helper to format duration into a readable MM:SS format.
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void initState() {
    _trackBloc = context.read<TrackPlayerBloc>();
    _trackBloc.add(LoadTrack(track: widget.track));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // BlocBuilder rebuilds the widget in response to new states from TrackPlayerBloc.
    return BlocBuilder<TrackPlayerBloc, TrackPlayerState>(
      bloc: _trackBloc,
      builder: (context, state) {
        // Determine if the player is in a playable state.
        final isPlaying = state.status == PlayerStatus.playing;

        // Disable controls if the track is still loading or in an initial state.
        final canInteract =
            state.status != PlayerStatus.initial &&
            state.status != PlayerStatus.loading;

        return Column(
          children: [
            Slider(
              value: state.currentPosition.inSeconds.toDouble(),
              // Ensure max value is at least 1.0 to avoid errors if duration is zero.
              max: state.totalDuration.inSeconds > 0
                  ? state.totalDuration.inSeconds.toDouble()
                  : 1.0,
              onChanged: canInteract
                  ? (value) {
                      // Dispatch a seek event when the user finishes dragging the slider.
                      _trackBloc.add(
                        SeekRequested(Duration(seconds: value.round())),
                      );
                    }
                  : null, // Disable slider interaction
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(state.currentPosition)),
                Text(_formatDuration(state.totalDuration)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const IconButton(
                  icon: Icon(Icons.shuffle, size: 28),
                  onPressed: null,
                ),
                const IconButton(
                  icon: Icon(Icons.skip_previous, size: 36),
                  onPressed: null,
                ),

                // Show a loading indicator or the play/pause button based on state.
                if (state.status == PlayerStatus.loading)
                  const SizedBox(
                    height: 72,
                    width: 72,
                    child: CircularProgressIndicator(),
                  )
                else
                  IconButton(
                    iconSize: 72,
                    icon: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                    ),
                    // Dispatch Play or Pause events on tap.
                    onPressed: canInteract
                        ? () {
                            if (isPlaying) {
                              _trackBloc.add(PauseRequested());
                            } else {
                              _trackBloc.add(PlayRequested());
                            }
                          }
                        : null,
                  ),
                const IconButton(
                  icon: Icon(Icons.skip_next, size: 36),
                  onPressed: null,
                ),
                const IconButton(
                  icon: Icon(Icons.repeat, size: 28),
                  onPressed: null,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
