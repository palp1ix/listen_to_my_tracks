import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/data/models/artist/artist_model.dart';

void main() {
  group('ArtistModel', () {
    const tArtistModel = ArtistModel(
      id: 1,
      name: 'Eminem',
      imageUrl: 'https://example.com/artist.jpg',
    );

    test('should be a subclass of Equatable', () {
      expect(tArtistModel, isA<Equatable>());
    });

    test('should have correct properties', () {
      expect(tArtistModel.id, 1);
      expect(tArtistModel.name, 'Eminem');
      expect(tArtistModel.imageUrl, 'https://example.com/artist.jpg');
    });

    test('should support equality', () {
      const tArtistModel2 = ArtistModel(
        id: 1,
        name: 'Eminem',
        imageUrl: 'https://example.com/artist.jpg',
      );
      
      expect(tArtistModel, equals(tArtistModel2));
    });

    test('should support inequality', () {
      const tArtistModel2 = ArtistModel(
        id: 2,
        name: 'Eminem',
        imageUrl: 'https://example.com/artist.jpg',
      );
      
      expect(tArtistModel, isNot(equals(tArtistModel2)));
    });

    group('fromJson', () {
      test('should return a valid ArtistModel when the JSON is valid', () {
        final json = {
          'id': 1,
          'name': 'Eminem',
          'picture_big': 'https://example.com/artist.jpg',
        };

        final result = ArtistModel.fromJson(json);

        expect(result, equals(tArtistModel));
      });

      test('should handle null imageUrl', () {
        final json = {
          'id': 1,
          'name': 'Eminem',
          'picture_big': null,
        };

        final result = ArtistModel.fromJson(json);

        expect(result.id, 1);
        expect(result.name, 'Eminem');
        expect(result.imageUrl, isNull);
      });

      test('should handle missing picture_big field', () {
        final json = {
          'id': 1,
          'name': 'Eminem',
        };

        final result = ArtistModel.fromJson(json);

        expect(result.id, 1);
        expect(result.name, 'Eminem');
        expect(result.imageUrl, isNull);
      });
    });

    group('toJson', () {
      test('should return a valid JSON map', () {
        final result = tArtistModel.toJson();

        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], 1);
        expect(result['name'], 'Eminem');
        expect(result['picture_big'], 'https://example.com/artist.jpg');
      });

      test('should handle null imageUrl in JSON', () {
        const tArtistModelWithNullImage = ArtistModel(
          id: 1,
          name: 'Eminem',
          imageUrl: null,
        );

        final result = tArtistModelWithNullImage.toJson();

        expect(result, isA<Map<String, dynamic>>());
        expect(result['id'], 1);
        expect(result['name'], 'Eminem');
        expect(result['picture_big'], isNull);
      });
    });
  });
}
