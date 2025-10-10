import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/app/router/router.gr.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/features/details/bloc/track_player_bloc.dart';
import 'package:listen_to_my_tracks/features/details/widgets/warning_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

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
            builder: (BuildContext buttonContext) {
              return IconButton(
                icon: const Icon(Icons.ios_share),
                onPressed: () => _onSharePressed(buttonContext),
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
              artist: widget.track.artist,
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

  Future<void> _onSharePressed(BuildContext anchorContext) async {
    // Find the RenderBox of the IconButton to get its size and position.
    final RenderBox? box = anchorContext.findRenderObject() as RenderBox?;

    if (box == null) return;

    // The share method needs the global position of the button.
    final Rect sharePositionOrigin = box.localToGlobal(Offset.zero) & box.size;

    // Prepare share text (ensure https URL so iOS resolves more targets like Messages/Telegram)
    final String trackUrl = widget.track.link;
    final String shareText = 'Check out this track! $trackUrl';

    // Try to fetch album cover and attach as image to improve preview on iOS.
    List<XFile> files = [];
    try {
      final coverUrl = widget.track.album.coverUrl;
      if (coverUrl.isNotEmpty) {
        final response = await Dio().get<List<int>>(
          coverUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = response.data;
        if (bytes != null && bytes.isNotEmpty) {
          files = [
            XFile.fromData(
              Uint8List.fromList(bytes),
              name: 'cover',
              mimeType: 'image/jpeg',
            ),
          ];
        }
      }
    } catch (_) {
      // If download fails, we still proceed with URL/text sharing only.
    }

    // Use the new Share Plus v12 API with ShareParams.
    SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: 'deezer.com',
        files: files,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}

// This widget doesn't need to change as it's purely presentational.
class _TrackInfoSection extends StatelessWidget {
  const _TrackInfoSection({required this.title, required this.artist});
  final String title;
  final ArtistEntity artist;

  @override
  Widget build(BuildContext context) {
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
        TextButton(
          onPressed: () => _onArtistPressed(context),
          child: Text(
            artist.name,
            style: textTheme.titleLarge?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // Call this method when the artist name is pressed.
  void _onArtistPressed(BuildContext context) {
    // Get the current navigation stack
    final stack = context.router.stack;

    // Check if the previous route is ArtistTracksRoute
    if (stack.length > 1 &&
        stack[stack.length - 2].name == ArtistTracksRoute.name) {
      // If it is, we pop back to it instead of pushing a new one
      context.router.back();
    } else {
      // Otherwise, we push a new ArtistTracksRoute
      context.router.push(ArtistTracksRoute(artist: artist));
    }
    
    // Pause the track when navigating away
    context.read<TrackPlayerBloc>().add(PauseRequested());
  }
}

// This widget also remains unchanged.
class _AlbumArtSection extends StatefulWidget {
  const _AlbumArtSection({required this.coverUrl});
  final String coverUrl;

  @override
  State<_AlbumArtSection> createState() => _AlbumArtSectionState();
}

class _AlbumArtSectionState extends State<_AlbumArtSection> {
  late final TrackPlayerBloc _playerBloc;
  // Track whether the player is currently playing or paused to adjust padding.
  bool _isPlaying = false;

  @override
  void initState() {
    _playerBloc = context.read<TrackPlayerBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TrackPlayerBloc, TrackPlayerState>(
      bloc: _playerBloc,
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == PlayerStatus.playing) {
          setState(() {
            _isPlaying = true;
          });
        } else if (state.status == PlayerStatus.paused ||
            state.status == PlayerStatus.completed ||
            state.status == PlayerStatus.error) {
          setState(() {
            _isPlaying = false;
          });
        }
      },
      child: AnimatedPadding(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(horizontal: _isPlaying ? 20 : 30),
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(widget.coverUrl, fit: BoxFit.cover),
          ),
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
