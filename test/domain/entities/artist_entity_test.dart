import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';

void main() {
  group('ArtistEntity', () {
    const tArtistEntity = ArtistEntity(
      id: 1,
      name: 'Eminem',
      imageUrl: 'https://example.com/artist.jpg',
    );

    test('should be a subclass of Equatable', () {
      expect(tArtistEntity, isA<Equatable>());
    });

    test('should have correct properties', () {
      expect(tArtistEntity.id, 1);
      expect(tArtistEntity.name, 'Eminem');
      expect(tArtistEntity.imageUrl, 'https://example.com/artist.jpg');
    });

    test('should support equality', () {
      const tArtistEntity2 = ArtistEntity(
        id: 1,
        name: 'Eminem',
        imageUrl: 'https://example.com/artist.jpg',
      );
      
      expect(tArtistEntity, equals(tArtistEntity2));
    });

    test('should support inequality when id is different', () {
      const tArtistEntity2 = ArtistEntity(
        id: 2,
        name: 'Eminem',
        imageUrl: 'https://example.com/artist.jpg',
      );
      
      expect(tArtistEntity, isNot(equals(tArtistEntity2)));
    });

    test('should support inequality when name is different', () {
      const tArtistEntity2 = ArtistEntity(
        id: 1,
        name: 'Drake',
        imageUrl: 'https://example.com/artist.jpg',
      );
      
      expect(tArtistEntity, isNot(equals(tArtistEntity2)));
    });

    test('should support inequality when imageUrl is different', () {
      const tArtistEntity2 = ArtistEntity(
        id: 1,
        name: 'Eminem',
        imageUrl: 'https://example.com/different.jpg',
      );
      
      expect(tArtistEntity, isNot(equals(tArtistEntity2)));
    });

    test('should handle empty strings', () {
      const tArtistEntityWithEmptyStrings = ArtistEntity(
        id: 1,
        name: '',
        imageUrl: '',
      );

      expect(tArtistEntityWithEmptyStrings.name, '');
      expect(tArtistEntityWithEmptyStrings.imageUrl, '');
    });

    test('should handle special characters in name', () {
      const tArtistEntityWithSpecialChars = ArtistEntity(
        id: 1,
        name: 'Eminem & Dr. Dre',
        imageUrl: 'https://example.com/artist.jpg',
      );

      expect(tArtistEntityWithSpecialChars.name, 'Eminem & Dr. Dre');
    });

    test('should handle long URLs', () {
      const longUrl = 'https://example.com/very/long/path/to/artist/image/with/many/segments/and/parameters?param1=value1&param2=value2';
      const tArtistEntityWithLongUrl = ArtistEntity(
        id: 1,
        name: 'Eminem',
        imageUrl: longUrl,
      );

      expect(tArtistEntityWithLongUrl.imageUrl, longUrl);
    });
  });
}
