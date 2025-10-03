import 'package:equatable/equatable.dart';

// Represents an album in the domain layer.
// It's part of the TrackEntity and holds essential display information.
class AlbumEntity extends Equatable {
  const AlbumEntity({
    required this.id,
    required this.title,
    required this.coverUrl,
  });

  final int id;
  final String title;
  final String coverUrl;

  @override
  List<Object?> get props => [id, title, coverUrl];
}
