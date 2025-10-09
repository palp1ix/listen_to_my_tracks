import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/data/datasources/music_remote_datasource.dart';
import 'package:listen_to_my_tracks/data/models/album/album_model.dart';
import 'package:listen_to_my_tracks/data/models/artist/artist_model.dart';
import 'package:listen_to_my_tracks/data/models/track/track_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'music_remote_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late MusicRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = MusicRemoteDataSourceImpl(dio: mockDio);
  });

  group('searchTracks', () {
    const tQuery = 'eminem';
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
    final tTrackModelList = [tTrackModel];
    final tResponseData = {
      'data': [
        {
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
        },
      ],
    };

    test('should return List<TrackModel> when the call is successful', () async {
      // Arrange
      when(mockDio.get('/search', queryParameters: {'q': tQuery}))
          .thenAnswer((_) async => Response(
                data: tResponseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: '/search'),
              ));

      // Act
      final result = await dataSource.searchTracks(query: tQuery);

      // Assert
      verify(mockDio.get('/search', queryParameters: {'q': tQuery}));
      expect(result, equals(tTrackModelList));
    });

    test('should throw ServerException when status code is not 200', () async {
      // Arrange
      when(mockDio.get('/search', queryParameters: {'q': tQuery}))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 404,
                statusMessage: 'Not Found',
                requestOptions: RequestOptions(path: '/search'),
              ));

      // Act & Assert
      expect(
        () => dataSource.searchTracks(query: tQuery),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw NetworkException when DioException is connection error', () async {
      // Arrange
      when(mockDio.get('/search', queryParameters: {'q': tQuery}))
          .thenThrow(DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/search'),
          ));

      // Act & Assert
      expect(
        () => dataSource.searchTracks(query: tQuery),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should throw NetworkException when DioException is send timeout', () async {
      // Arrange
      when(mockDio.get('/search', queryParameters: {'q': tQuery}))
          .thenThrow(DioException(
            type: DioExceptionType.sendTimeout,
            requestOptions: RequestOptions(path: '/search'),
          ));

      // Act & Assert
      expect(
        () => dataSource.searchTracks(query: tQuery),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should throw NetworkException when DioException is receive timeout', () async {
      // Arrange
      when(mockDio.get('/search', queryParameters: {'q': tQuery}))
          .thenThrow(DioException(
            type: DioExceptionType.receiveTimeout,
            requestOptions: RequestOptions(path: '/search'),
          ));

      // Act & Assert
      expect(
        () => dataSource.searchTracks(query: tQuery),
        throwsA(isA<NetworkException>()),
      );
    });

    test('should throw ServerException when DioException is other type', () async {
      // Arrange
      when(mockDio.get('/search', queryParameters: {'q': tQuery}))
          .thenThrow(DioException(
            type: DioExceptionType.badResponse,
            message: 'Bad response',
            requestOptions: RequestOptions(path: '/search'),
          ));

      // Act & Assert
      expect(
        () => dataSource.searchTracks(query: tQuery),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerException when DioException has no message', () async {
      // Arrange
      when(mockDio.get('/search', queryParameters: {'q': tQuery}))
          .thenThrow(DioException(
            type: DioExceptionType.badResponse,
            requestOptions: RequestOptions(path: '/search'),
          ));

      // Act & Assert
      expect(
        () => dataSource.searchTracks(query: tQuery),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getChart', () {
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
    final tTrackModelList = [tTrackModel];
    final tResponseData = {
      'tracks': {
        'data': [
          {
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
          },
        ],
      },
    };

    test('should return List<TrackModel> when the call is successful', () async {
      // Arrange
      when(mockDio.get('/chart'))
          .thenAnswer((_) async => Response(
                data: tResponseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: '/chart'),
              ));

      // Act
      final result = await dataSource.getChart();

      // Assert
      verify(mockDio.get('/chart'));
      expect(result, equals(tTrackModelList));
    });

    test('should throw ServerException when status code is not 200', () async {
      // Arrange
      when(mockDio.get('/chart'))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 500,
                statusMessage: 'Internal Server Error',
                requestOptions: RequestOptions(path: '/chart'),
              ));

      // Act & Assert
      expect(
        () => dataSource.getChart(),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw NetworkException when DioException is connection error', () async {
      // Arrange
      when(mockDio.get('/chart'))
          .thenThrow(DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/chart'),
          ));

      // Act & Assert
      expect(
        () => dataSource.getChart(),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('getArtistTracks', () {
    const tArtistId = 1;
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
    final tTrackModelList = [tTrackModel];
    final tResponseData = {
      'data': [
        {
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
        },
      ],
    };

    test('should return List<TrackModel> when the call is successful', () async {
      // Arrange
      when(mockDio.get('/artist/$tArtistId/top', queryParameters: {'limit': 50}))
          .thenAnswer((_) async => Response(
                data: tResponseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: '/artist/$tArtistId/top'),
              ));

      // Act
      final result = await dataSource.getArtistTracks(artistId: tArtistId);

      // Assert
      verify(mockDio.get('/artist/$tArtistId/top', queryParameters: {'limit': 50}));
      expect(result, equals(tTrackModelList));
    });

    test('should throw ServerException when status code is not 200', () async {
      // Arrange
      when(mockDio.get('/artist/$tArtistId/top', queryParameters: {'limit': 50}))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 404,
                statusMessage: 'Artist not found',
                requestOptions: RequestOptions(path: '/artist/$tArtistId/top'),
              ));

      // Act & Assert
      expect(
        () => dataSource.getArtistTracks(artistId: tArtistId),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw NetworkException when DioException is connection error', () async {
      // Arrange
      when(mockDio.get('/artist/$tArtistId/top', queryParameters: {'limit': 50}))
          .thenThrow(DioException(
            type: DioExceptionType.connectionError,
            requestOptions: RequestOptions(path: '/artist/$tArtistId/top'),
          ));

      // Act & Assert
      expect(
        () => dataSource.getArtistTracks(artistId: tArtistId),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
