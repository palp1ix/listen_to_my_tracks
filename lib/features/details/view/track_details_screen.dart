import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class TrackDetailsScreen extends StatelessWidget {
  const TrackDetailsScreen({super.key, required this.track});

  final TrackEntity track;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // A minimal AppBar that only contains navigation and action controls.
      appBar: AppBar(
        // Makes the AppBar blend with the background.
        backgroundColor: Colors.transparent,
        elevation: 0,
        // The back button, styled as a chevron down, common in modal screens.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // A popup menu for actions like sharing.
          PopupMenuButton<void>(
            onSelected: (_) {
              // The track's web link is shared using the share_plus package.
              SharePlus.instance.share(
                ShareParams(
                  text: track.title,
                  subject:
                      'Check out this track: ${track.title} by ${track.artist.name}',
                  uri: Uri(path: track.link),
                ),
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<void>>[
              const PopupMenuItem<void>(
                value: null, // Value is not used here
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
        // The main layout is a Column containing all the UI elements.
        child: Column(
          children: [
            _TrackInfoSection(title: track.title, artist: track.artist.name),
            SizedBox(height: 24),
            _AlbumArtSection(coverUrl: track.album.coverUrl),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Text(
                    'You can try 30 seconds preview of this track',
                    maxLines: 2,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                const _PlayerSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Displays the track title and artist name.
class _TrackInfoSection extends StatelessWidget {
  const _TrackInfoSection({required this.title, required this.artist});

  final String title;
  final String artist;

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

// Displays the circular album art.
class _AlbumArtSection extends StatelessWidget {
  const _AlbumArtSection({required this.coverUrl});

  final String coverUrl;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(coverUrl, fit: BoxFit.cover),
      ),
    );
  }
}

// Contains the player slider, time indicators, and control buttons.
class _PlayerSection extends StatefulWidget {
  const _PlayerSection();

  @override
  State<_PlayerSection> createState() => _PlayerSectionState();
}

class _PlayerSectionState extends State<_PlayerSection> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main player controls: shuffle, skip, play/pause, etc.
        IconButton(
          iconSize: 72,
          icon: Icon(
            _isPlaying
                ? Icons.pause_circle_filled_rounded
                : Icons.play_circle_filled_rounded,
          ),
          onPressed: () {
            // This will be replaced by sending an event to the BLoC.
            setState(() => _isPlaying = !_isPlaying);
          },
        ),
      ],
    );
  }
}
