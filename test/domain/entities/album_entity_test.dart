import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/domain/entities/album.dart';

void main() {
  group('AlbumEntity', () {
    const tAlbumEntity = AlbumEntity(
      id: 1,
      title: 'The Eminem Show',
      coverUrl: 'https://example.com/album.jpg',
    );

    test('should be a subclass of Equatable', () {
      expect(tAlbumEntity, isA<Equatable>());
    });

    test('should have correct properties', () {
      expect(tAlbumEntity.id, 1);
      expect(tAlbumEntity.title, 'The Eminem Show');
      expect(tAlbumEntity.coverUrl, 'https://example.com/album.jpg');
    });

    test('should support equality', () {
      const tAlbumEntity2 = AlbumEntity(
        id: 1,
        title: 'The Eminem Show',
        coverUrl: 'https://example.com/album.jpg',
      );
      
      expect(tAlbumEntity, equals(tAlbumEntity2));
    });

    test('should support inequality when id is different', () {
      const tAlbumEntity2 = AlbumEntity(
        id: 2,
        title: 'The Eminem Show',
        coverUrl: 'https://example.com/album.jpg',
      );
      
      expect(tAlbumEntity, isNot(equals(tAlbumEntity2)));
    });

    test('should support inequality when title is different', () {
      const tAlbumEntity2 = AlbumEntity(
        id: 1,
        title: 'Recovery',
        coverUrl: 'https://example.com/album.jpg',
      );
      
      expect(tAlbumEntity, isNot(equals(tAlbumEntity2)));
    });

    test('should support inequality when coverUrl is different', () {
      const tAlbumEntity2 = AlbumEntity(
        id: 1,
        title: 'The Eminem Show',
        coverUrl: 'https://example.com/different.jpg',
      );
      
      expect(tAlbumEntity, isNot(equals(tAlbumEntity2)));
    });

    test('should handle empty strings', () {
      const tAlbumEntityWithEmptyStrings = AlbumEntity(
        id: 1,
        title: '',
        coverUrl: '',
      );

      expect(tAlbumEntityWithEmptyStrings.title, '');
      expect(tAlbumEntityWithEmptyStrings.coverUrl, '');
    });

    test('should handle special characters in title', () {
      const tAlbumEntityWithSpecialChars = AlbumEntity(
        id: 1,
        title: 'The Eminem Show: Special Edition',
        coverUrl: 'https://example.com/album.jpg',
      );

      expect(tAlbumEntityWithSpecialChars.title, 'The Eminem Show: Special Edition');
    });

    test('should handle long URLs', () {
      const longUrl = 'https://example.com/very/long/path/to/album/cover/with/many/segments/and/parameters?param1=value1&param2=value2';
      const tAlbumEntityWithLongUrl = AlbumEntity(
        id: 1,
        title: 'The Eminem Show',
        coverUrl: longUrl,
      );

      expect(tAlbumEntityWithLongUrl.coverUrl, longUrl);
    });

    test('should handle numeric titles', () {
      const tAlbumEntityWithNumericTitle = AlbumEntity(
        id: 1,
        title: '2001',
        coverUrl: 'https://example.com/album.jpg',
      );

      expect(tAlbumEntityWithNumericTitle.title, '2001');
    });
  });
}
