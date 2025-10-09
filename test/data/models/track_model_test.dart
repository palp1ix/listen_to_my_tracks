import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/data/models/album/album_model.dart';
import 'package:listen_to_my_tracks/data/models/artist/artist_model.dart';
import 'package:listen_to_my_tracks/data/models/track/track_model.dart';

void main() {
  group('TrackModel', () {
    const tArtistModel = ArtistModel(
      id: 1,
      name: 'Eminem',
      imageUrl: 'https://example.com/artist.jpg',
    );
    
    const tAlbumModel = AlbumModel(
      id: 1,
      title: 'The Eminem Show',
      coverUrl: 'https://example.com/album.jpg',
    );
    
    const tTrackModel = TrackModel(
      id: 1,
      title: 'Without Me',
      link: 'https://example.com/track',
      duration: 290,
      previewUrl: 'https://example.com/preview.mp3',
      artist: tArtistModel,
      album: tAlbumModel,
    );

    test('should be a subclass of Equatable', () {
      expect(tTrackModel, isA<Equatable>());
    });

    test('should have correct properties', () {
      expect(tTrackModel.id, 1);
      expect(tTrackModel.title, 'Without Me');
      expect(tTrackModel.link, 'https://example.com/track');
      expect(tTrackModel.duration, 290);
      expect(tTrackModel.previewUrl, 'https://example.com/preview.mp3');
      expect(tTrackModel.artist, tArtistModel);
      expect(tTrackModel.album, tAlbumModel);
    });

    test('should support equality', () {
      const tTrackModel2 = TrackModel(
        id: 1,
        title: 'Without Me',
        link: 'https://example.com/track',
        duration: 290,
        previewUrl: 'https://example.com/preview.mp3',
        artist: tArtistModel,
        album: tAlbumModel,
      );
      
      expect(tTrackModel, equals(tTrackModel2));
    });

    test('should support inequality', () {
      const tTrackModel2 = TrackModel(
        id: 2,
        title: 'Without Me',
        link: 'https://example.com/track',
        duration: 290,
        previewUrl: 'https://example.com/preview.mp3',
        artist: tArtistModel,
        album: tAlbumModel,
      );
      
      expect(tTrackModel, isNot(equals(tTrackModel2)));
    });

    group('fromJson', () {
      test('should return a valid TrackModel when the JSON is valid', () {
        final json = {
          'id': 1,
          'title': 'Without Me',
          'link': 'https://example.com/track',
          'duration': 290,
          'preview': 'https://example.com/preview.mp3',
          'artist': {
            'id': 1,
            'name': 'Eminem',
            'picture_big': 'https://example.com/artist.jpg',
          },
          'album': {
            'id': 1,
            'title': 'The Eminem Show',
            'cover_big': 'https://example.com/album.jpg',
          },
        };

        final result = TrackModel.fromJson(json);

        expect(result, equals(tTrackModel));
      });

      test('should handle null preview URL', () {
        final json = {
          'id': 1,
          'title': 'Without Me',
          'link': 'https://example.com/track',
          'duration': 290,
          'preview': null,
          'artist': {
            'id': 1,
            'name': 'Eminem',
            'picture_big': 'https://example.com/artist.jpg',
          },
          'album': {
            'id': 1,
            'title': 'The Eminem Show',
            'cover_big': 'https://example.com/album.jpg',
          },
        };

        final result = TrackModel.fromJson(json);

        expect(result.previewUrl, isNull);
      });
    });

    group('toJson', () {
      test('should return a valid JSON map', () {
        final result = tTrackModel.toJson();

        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], 1);
        expect(result['title'], 'Without Me');
        expect(result['link'], 'https://example.com/track');
        expect(result['duration'], 290);
        expect(result['preview'], 'https://example.com/preview.mp3');
        expect(result['artist'], isA<Map<String, dynamic>>());
        expect(result['album'], isA<Map<String, dynamic>>());
      });
    });
  });

  group('TrackSearchResponse', () {
    const tTrackModel1 = TrackModel(
      id: 1,
      title: 'Track 1',
      link: 'https://example.com/track1',
      duration: 180,
      previewUrl: 'https://example.com/preview1.mp3',
      artist: ArtistModel(id: 1, name: 'Artist 1', imageUrl: 'https://example.com/artist1.jpg'),
      album: AlbumModel(id: 1, title: 'Album 1', coverUrl: 'https://example.com/album1.jpg'),
    );
    
    const tTrackModel2 = TrackModel(
      id: 2,
      title: 'Track 2',
      link: 'https://example.com/track2',
      duration: 240,
      previewUrl: 'https://example.com/preview2.mp3',
      artist: ArtistModel(id: 2, name: 'Artist 2', imageUrl: 'https://example.com/artist2.jpg'),
      album: AlbumModel(id: 2, title: 'Album 2', coverUrl: 'https://example.com/album2.jpg'),
    );
    
    const tTrackSearchResponse = TrackSearchResponse(
      data: [tTrackModel1, tTrackModel2],
    );

    test('should be a subclass of Equatable', () {
      expect(tTrackSearchResponse, isA<Equatable>());
    });

    test('should have correct properties', () {
      expect(tTrackSearchResponse.data, [tTrackModel1, tTrackModel2]);
    });

    test('should support equality', () {
      const tTrackSearchResponse2 = TrackSearchResponse(
        data: [tTrackModel1, tTrackModel2],
      );
      
      expect(tTrackSearchResponse, equals(tTrackSearchResponse2));
    });

    group('fromJson', () {
      test('should return a valid TrackSearchResponse when the JSON is valid', () {
        final json = {
          'data': [
            {
              'id': 1,
              'title': 'Track 1',
              'link': 'https://example.com/track1',
              'duration': 180,
              'preview': 'https://example.com/preview1.mp3',
              'artist': {
                'id': 1,
                'name': 'Artist 1',
                'picture_big': 'https://example.com/artist1.jpg',
              },
              'album': {
                'id': 1,
                'title': 'Album 1',
                'cover_big': 'https://example.com/album1.jpg',
              },
            },
            {
              'id': 2,
              'title': 'Track 2',
              'link': 'https://example.com/track2',
              'duration': 240,
              'preview': 'https://example.com/preview2.mp3',
              'artist': {
                'id': 2,
                'name': 'Artist 2',
                'picture_big': 'https://example.com/artist2.jpg',
              },
              'album': {
                'id': 2,
                'title': 'Album 2',
                'cover_big': 'https://example.com/album2.jpg',
              },
            },
          ],
        };

        final result = TrackSearchResponse.fromJson(json);

        expect(result, equals(tTrackSearchResponse));
      });

      test('should handle empty data list', () {
        final json = {'data': []};

        final result = TrackSearchResponse.fromJson(json);

        expect(result.data, isEmpty);
      });
    });

    group('toJson', () {
      test('should return a valid JSON map', () {
        final result = tTrackSearchResponse.toJson();

        expect(result, isA<Map<String, dynamic>>());
        expect(result['data'], isA<List>());
        expect(result['data'].length, 2);
      });
    });
  });
}
