import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/data/models/album/album_model.dart';

void main() {
  group('AlbumModel', () {
    const tAlbumModel = AlbumModel(
      id: 1,
      title: 'The Eminem Show',
      coverUrl: 'https://example.com/album.jpg',
    );

    test('should be a subclass of Equatable', () {
      expect(tAlbumModel, isA<Equatable>());
    });

    test('should have correct properties', () {
      expect(tAlbumModel.id, 1);
      expect(tAlbumModel.title, 'The Eminem Show');
      expect(tAlbumModel.coverUrl, 'https://example.com/album.jpg');
    });

    test('should support equality', () {
      const tAlbumModel2 = AlbumModel(
        id: 1,
        title: 'The Eminem Show',
        coverUrl: 'https://example.com/album.jpg',
      );
      
      expect(tAlbumModel, equals(tAlbumModel2));
    });

    test('should support inequality', () {
      const tAlbumModel2 = AlbumModel(
        id: 2,
        title: 'The Eminem Show',
        coverUrl: 'https://example.com/album.jpg',
      );
      
      expect(tAlbumModel, isNot(equals(tAlbumModel2)));
    });

    group('fromJson', () {
      test('should return a valid AlbumModel when the JSON is valid', () {
        final json = {
          'id': 1,
          'title': 'The Eminem Show',
          'cover_big': 'https://example.com/album.jpg',
        };

        final result = AlbumModel.fromJson(json);

        expect(result, equals(tAlbumModel));
      });

      test('should handle empty coverUrl', () {
        final json = {
          'id': 1,
          'title': 'The Eminem Show',
          'cover_big': '',
        };

        final result = AlbumModel.fromJson(json);

        expect(result.id, 1);
        expect(result.title, 'The Eminem Show');
        expect(result.coverUrl, '');
      });
    });

    group('toJson', () {
      test('should return a valid JSON map', () {
        final result = tAlbumModel.toJson();

        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], 1);
        expect(result['title'], 'The Eminem Show');
        expect(result['cover_big'], 'https://example.com/album.jpg');
      });
    });
  });
}
