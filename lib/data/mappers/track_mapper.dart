import 'package:listen_to_my_tracks/data/models/album/album_model.dart';
import 'package:listen_to_my_tracks/data/models/artist/artist_model.dart';
import 'package:listen_to_my_tracks/data/models/track/track_model.dart';
import 'package:listen_to_my_tracks/domain/entities/album.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';

// Using extension methods for mapping provides a clean, discoverable way
// to convert data transfer objects (DTOs) into domain entities.
// This decouples the data layer models from the domain layer entities.

extension AlbumModelMapper on AlbumModel {
  AlbumEntity toEntity() {
    return AlbumEntity(
      id: id,
      title: title,
      coverUrl: coverUrl,
    );
  }
}

extension ArtistModelMapper on ArtistModel {
  ArtistEntity toEntity() {
    return ArtistEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
    );
  }
}

extension TrackModelMapper on TrackModel {
  TrackEntity toEntity() {
    return TrackEntity(
      id: id,
      title: title,
      link: link,
      // The API provides duration in seconds, while the domain entity
      // expects a `Duration` object. This mapping handles the conversion.
      duration: Duration(seconds: duration),
      previewUrl: previewUrl,
      artist: artist.toEntity(),
      album: album.toEntity(),
    );
  }
}