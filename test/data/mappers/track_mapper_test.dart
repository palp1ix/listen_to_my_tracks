import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/data/models/album/album_model.dart';
import 'package:listen_to_my_tracks/data/models/artist/artist_model.dart';
import 'package:listen_to_my_tracks/data/models/track/track_model.dart';
import 'package:listen_to_my_tracks/data/mappers/track_mapper.dart';
import 'package:listen_to_my_tracks/domain/entities/album.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';

void main() {
  group('AlbumModelMapper', () {
    test('should convert AlbumModel to AlbumEntity correctly', () {
      const albumModel = AlbumModel(
        id: 1,
        title: 'The Eminem Show',
        coverUrl: 'https://example.com/album.jpg',
      );

      final result = albumModel.toEntity();

      expect(result, isA<AlbumEntity>());
      expect(result.id, 1);
      expect(result.title, 'The Eminem Show');
      expect(result.coverUrl, 'https://example.com/album.jpg');
    });

    test('should handle empty coverUrl', () {
      const albumModel = AlbumModel(
        id: 1,
        title: 'The Eminem Show',
        coverUrl: '',
      );

      final result = albumModel.toEntity();

      expect(result.id, 1);
      expect(result.title, 'The Eminem Show');
      expect(result.coverUrl, '');
    });
  });

  group('ArtistModelMapper', () {
    test('should convert ArtistModel to ArtistEntity correctly when imageUrl is not null', () {
      const artistModel = ArtistModel(
        id: 1,
        name: 'Eminem',
        imageUrl: 'https://example.com/artist.jpg',
      );

      final result = artistModel.toEntity();

      expect(result, isA<ArtistEntity>());
      expect(result.id, 1);
      expect(result.name, 'Eminem');
      expect(result.imageUrl, 'https://example.com/artist.jpg');
    });

    test('should convert ArtistModel to ArtistEntity correctly when imageUrl is null', () {
      const artistModel = ArtistModel(
        id: 1,
        name: 'Eminem',
        imageUrl: null,
      );

      final result = artistModel.toEntity();

      expect(result, isA<ArtistEntity>());
      expect(result.id, 1);
      expect(result.name, 'Eminem');
      expect(result.imageUrl, '');
    });
  });

  group('TrackModelMapper', () {
    test('should convert TrackModel to TrackEntity correctly', () {
      const artistModel = ArtistModel(
        id: 1,
        name: 'Eminem',
        imageUrl: 'https://example.com/artist.jpg',
      );
      
      const albumModel = AlbumModel(
        id: 1,
        title: 'The Eminem Show',
        coverUrl: 'https://example.com/album.jpg',
      );
      
      const trackModel = TrackModel(
        id: 1,
        title: 'Without Me',
        link: 'https://example.com/track',
        duration: 290,
        previewUrl: 'https://example.com/preview.mp3',
        artist: artistModel,
        album: albumModel,
      );

      final result = trackModel.toEntity();

      expect(result, isA<TrackEntity>());
      expect(result.id, 1);
      expect(result.title, 'Without Me');
      expect(result.link, 'https://example.com/track');
      expect(result.duration, const Duration(seconds: 290));
      expect(result.previewUrl, 'https://example.com/preview.mp3');
      expect(result.artist, isA<ArtistEntity>());
      expect(result.album, isA<AlbumEntity>());
    });

    test('should convert duration from seconds to Duration object', () {
      const artistModel = ArtistModel(
        id: 1,
        name: 'Eminem',
        imageUrl: 'https://example.com/artist.jpg',
      );
      
      const albumModel = AlbumModel(
        id: 1,
        title: 'The Eminem Show',
        coverUrl: 'https://example.com/album.jpg',
      );
      
      const trackModel = TrackModel(
        id: 1,
        title: 'Without Me',
        link: 'https://example.com/track',
        duration: 180,
        previewUrl: 'https://example.com/preview.mp3',
        artist: artistModel,
        album: albumModel,
      );

      final result = trackModel.toEntity();

      expect(result.duration, const Duration(seconds: 180));
    });

    test('should handle zero duration', () {
      const artistModel = ArtistModel(
        id: 1,
        name: 'Eminem',
        imageUrl: 'https://example.com/artist.jpg',
      );
      
      const albumModel = AlbumModel(
        id: 1,
        title: 'The Eminem Show',
        coverUrl: 'https://example.com/album.jpg',
      );
      
      const trackModel = TrackModel(
        id: 1,
        title: 'Without Me',
        link: 'https://example.com/track',
        duration: 0,
        previewUrl: 'https://example.com/preview.mp3',
        artist: artistModel,
        album: albumModel,
      );

      final result = trackModel.toEntity();

      expect(result.duration, Duration.zero);
    });

    test('should convert nested artist and album models correctly', () {
      const artistModel = ArtistModel(
        id: 2,
        name: 'Drake',
        imageUrl: null,
      );
      
      const albumModel = AlbumModel(
        id: 2,
        title: 'Views',
        coverUrl: 'https://example.com/views.jpg',
      );
      
      const trackModel = TrackModel(
        id: 2,
        title: 'One Dance',
        link: 'https://example.com/one-dance',
        duration: 180,
        previewUrl: 'https://example.com/one-dance-preview.mp3',
        artist: artistModel,
        album: albumModel,
      );

      final result = trackModel.toEntity();

      expect(result.artist.id, 2);
      expect(result.artist.name, 'Drake');
      expect(result.artist.imageUrl, '');
      expect(result.album.id, 2);
      expect(result.album.title, 'Views');
      expect(result.album.coverUrl, 'https://example.com/views.jpg');
    });
  });
}
