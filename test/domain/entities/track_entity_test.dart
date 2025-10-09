import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/domain/entities/album.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';

void main() {
  group('TrackEntity', () {
    const tArtistEntity = ArtistEntity(
      id: 1,
      name: 'Eminem',
      imageUrl: 'https://example.com/artist.jpg',
    );
    
    const tAlbumEntity = AlbumEntity(
      id: 1,
      title: 'The Eminem Show',
      coverUrl: 'https://example.com/album.jpg',
    );
    
    const tTrackEntity = TrackEntity(
      id: 1,
      title: 'Without Me',
      link: 'https://example.com/track',
      duration: Duration(seconds: 290),
      previewUrl: 'https://example.com/preview.mp3',
      artist: tArtistEntity,
      album: tAlbumEntity,
    );

    test('should be a subclass of Equatable', () {
      expect(tTrackEntity, isA<Equatable>());
    });

    test('should have correct properties', () {
      expect(tTrackEntity.id, 1);
      expect(tTrackEntity.title, 'Without Me');
      expect(tTrackEntity.link, 'https://example.com/track');
      expect(tTrackEntity.duration, const Duration(seconds: 290));
      expect(tTrackEntity.previewUrl, 'https://example.com/preview.mp3');
      expect(tTrackEntity.artist, tArtistEntity);
      expect(tTrackEntity.album, tAlbumEntity);
    });

    test('should support equality', () {
      const tTrackEntity2 = TrackEntity(
        id: 1,
        title: 'Without Me',
        link: 'https://example.com/track',
        duration: Duration(seconds: 290),
        previewUrl: 'https://example.com/preview.mp3',
        artist: tArtistEntity,
        album: tAlbumEntity,
      );
      
      expect(tTrackEntity, equals(tTrackEntity2));
    });

    test('should support inequality when id is different', () {
      const tTrackEntity2 = TrackEntity(
        id: 2,
        title: 'Without Me',
        link: 'https://example.com/track',
        duration: Duration(seconds: 290),
        previewUrl: 'https://example.com/preview.mp3',
        artist: tArtistEntity,
        album: tAlbumEntity,
      );
      
      expect(tTrackEntity, isNot(equals(tTrackEntity2)));
    });

    test('should support inequality when title is different', () {
      const tTrackEntity2 = TrackEntity(
        id: 1,
        title: 'Lose Yourself',
        link: 'https://example.com/track',
        duration: Duration(seconds: 290),
        previewUrl: 'https://example.com/preview.mp3',
        artist: tArtistEntity,
        album: tAlbumEntity,
      );
      
      expect(tTrackEntity, isNot(equals(tTrackEntity2)));
    });

    test('should support inequality when duration is different', () {
      const tTrackEntity2 = TrackEntity(
        id: 1,
        title: 'Without Me',
        link: 'https://example.com/track',
        duration: Duration(seconds: 180),
        previewUrl: 'https://example.com/preview.mp3',
        artist: tArtistEntity,
        album: tAlbumEntity,
      );
      
      expect(tTrackEntity, isNot(equals(tTrackEntity2)));
    });

    test('should support inequality when artist is different', () {
      const tArtistEntity2 = ArtistEntity(
        id: 2,
        name: 'Drake',
        imageUrl: 'https://example.com/drake.jpg',
      );
      
      const tTrackEntity2 = TrackEntity(
        id: 1,
        title: 'Without Me',
        link: 'https://example.com/track',
        duration: Duration(seconds: 290),
        previewUrl: 'https://example.com/preview.mp3',
        artist: tArtistEntity2,
        album: tAlbumEntity,
      );
      
      expect(tTrackEntity, isNot(equals(tTrackEntity2)));
    });

    test('should support inequality when album is different', () {
      const tAlbumEntity2 = AlbumEntity(
        id: 2,
        title: 'Recovery',
        coverUrl: 'https://example.com/recovery.jpg',
      );
      
      const tTrackEntity2 = TrackEntity(
        id: 1,
        title: 'Without Me',
        link: 'https://example.com/track',
        duration: Duration(seconds: 290),
        previewUrl: 'https://example.com/preview.mp3',
        artist: tArtistEntity,
        album: tAlbumEntity2,
      );
      
      expect(tTrackEntity, isNot(equals(tTrackEntity2)));
    });

    test('should handle zero duration', () {
      const tTrackEntityWithZeroDuration = TrackEntity(
        id: 1,
        title: 'Without Me',
        link: 'https://example.com/track',
        duration: Duration.zero,
        previewUrl: 'https://example.com/preview.mp3',
        artist: tArtistEntity,
        album: tAlbumEntity,
      );

      expect(tTrackEntityWithZeroDuration.duration, Duration.zero);
    });

    test('should handle empty strings', () {
      const tTrackEntityWithEmptyStrings = TrackEntity(
        id: 1,
        title: '',
        link: '',
        duration: Duration(seconds: 290),
        previewUrl: '',
        artist: tArtistEntity,
        album: tAlbumEntity,
      );

      expect(tTrackEntityWithEmptyStrings.title, '');
      expect(tTrackEntityWithEmptyStrings.link, '');
      expect(tTrackEntityWithEmptyStrings.previewUrl, '');
    });
  });
}
