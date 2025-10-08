import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/app/resources/colors.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/features/details/bloc/track_player_bloc.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class TrackDetailsScreen extends StatefulWidget {
  const TrackDetailsScreen({super.key, required this.track});

  final TrackEntity track;

  @override
  State<TrackDetailsScreen> createState() => _TrackDetailsScreenState();
}

class _TrackDetailsScreenState extends State<TrackDetailsScreen> {
  late final TrackPlayerBloc _trackBloc;

  @override
  void initState() {
    _trackBloc = context.read<TrackPlayerBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We use BlocProvider to create and provide the TrackPlayerBloc to the widget tree.
    // The BLoC is created only once when this screen is built.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _trackBloc.add(PauseRequested());
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // We use a Builder to get a context that is a descendant of the IconButton.
          // This is crucial for correctly finding the RenderBox of the button.
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.ios_share),
                onPressed: () {
                  // Find the RenderBox of the IconButton to get its size and position.
                  final RenderBox? box =
                      context.findRenderObject() as RenderBox?;

                  if (box != null) {
                    // The share method needs the global position of the button.
                    final Rect sharePositionOrigin =
                        box.localToGlobal(Offset.zero) & box.size;

                    // Now we call share, providing the link and the origin rectangle.
                    SharePlus.instance.share(
                      ShareParams(
                        title: 'Check out this track!',
                        subject: 'deezer.com',
                        uri: Uri(path: widget.track.link),
                        sharePositionOrigin: sharePositionOrigin,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            _TrackInfoSection(
              title: widget.track.title,
              artist: widget.track.artist.name,
            ),
            SizedBox(height: 20),
            _AlbumArtSection(coverUrl: widget.track.album.coverUrl),
            SizedBox(height: 20),
            // The _PlayerSection is now connected to the BLoC.
            _PlayerSection(widget.track),
            SizedBox(height: 20),
            WarningWidget(),
          ],
        ),
      ),
    );
  }
}

class WarningWidget extends StatelessWidget {
  const WarningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warning, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dangerous_rounded, color: AppColors.warning, size: 45),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                'You can only play 30 seconds of this track. API has this limitation.',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: theme.textTheme.bodyLarge?.copyWith(
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(coverUrl, fit: BoxFit.cover),
        ),
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
    final theme = Theme.of(context);

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

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Slider(
                    activeColor: theme.colorScheme.onSurface,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 20),
                      Text(
                        _formatDuration(state.currentPosition),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        _formatDuration(state.totalDuration),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
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
                  isPlaying
                      ? Icons.pause_circle_rounded
                      : Icons.play_circle_rounded,
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
          ],
        );
      },
    );
  }
}
