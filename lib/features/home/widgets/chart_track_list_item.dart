// The list item for the chart, including its rank.
import 'package:flutter/material.dart';
import 'package:listen_to_my_tracks/core/widgets/track_list_tile.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';

class ChartTrackListItem extends StatelessWidget {
  const ChartTrackListItem({super.key, required this.track, required this.rank});

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
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.6,
                  ),
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