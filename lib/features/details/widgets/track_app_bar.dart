// The old name was MovieAppBar, I suggest TrackAppBar for consistency
import 'package:flutter/material.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';

class TrackAppBar extends StatefulWidget {
  const TrackAppBar({
    super.key,
    required this.track,
    required this.scrollController,
  });

  final TrackEntity track;
  final ScrollController scrollController;

  @override
  State<TrackAppBar> createState() => _TrackAppBarState();
}

class _TrackAppBarState extends State<TrackAppBar> {
  double _opacity = 0.0;

  void _scrollListener() {
    // Defines how quickly the gradient fades in.
    // 400 is the expandedHeight of the SliverAppBar.
    // The -kToolbarHeight ensures the fade completes when the app bar is fully collapsed.
    const scrollOffsetThreshold = 400 - kToolbarHeight;
    final opacity = (widget.scrollController.offset / scrollOffsetThreshold);
    
    // We only need to rebuild if the opacity value actually changes.
    if (_opacity != opacity) {
      setState(() {
        _opacity = opacity.clamp(0.0, 1.0);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Add the listener to the passed controller.
    widget.scrollController.addListener(_scrollListener);
  }

  // CRITICAL FIX: The controller is managed by the parent widget,
  // so we should not dispose of it here. We only remove the listener.
  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 400,
      stretch: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent, // Prevents color change on scroll
      pinned: true, // The app bar will remain visible at the top
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Album cover image
            Image.network(
              widget.track.album.coverUrl,
              fit: BoxFit.cover,
            ),
            // The gradient overlay that fades in on scroll.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // The opacity of the gradient is controlled by the scroll offset.
                  colors: [
                    theme.colorScheme.surface.withValues(alpha: 0),
                    theme.colorScheme.surface.withValues(alpha: _opacity),
                    theme.colorScheme.surface,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}