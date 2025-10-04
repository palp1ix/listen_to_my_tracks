import 'package:equatable/equatable.dart';
import 'package:listen_to_my_tracks/domain/entities/album.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';

// The core entity of the application.
// It aggregates information about the track itself, its artist, and its album.
// Note the use of the `Duration` type for `duration`, which is more expressive
// and type-safe than a raw integer representing seconds.
class TrackEntity extends Equatable {
  const TrackEntity({
    required this.id,
    required this.title,
    required this.link,
    required this.duration,
    required this.previewUrl,
    required this.artist,
    required this.album,
  });

  final int id;
  final String title;
  final String link; // For the share functionality
  final Duration duration;
  final String previewUrl; // For the audio player
  final ArtistEntity artist;
  final AlbumEntity album;

  @override
  List<Object?> get props => [
    id,
    title,
    link,
    duration,
    previewUrl,
    artist,
    album,
  ];
}
