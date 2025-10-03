import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/data/datasources/music_remote_datasource.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/data/models/album/album_model.dart';
import 'package:listen_to_my_tracks/data/models/artist/artist_model.dart';
import 'package:listen_to_my_tracks/data/models/track/track_model.dart';
import 'package:listen_to_my_tracks/data/repositories/music_repository_impl.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/data/mappers/track_mapper.dart';

import 'music_repository_impl_test.mocks.dart';

@GenerateMocks([MusicRemoteDataSource])
void main() {
  late MockMusicRemoteDataSource mockRemoteDataSource;
  late MusicRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockMusicRemoteDataSource();
    repository = MusicRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('searchTracks', () {
    const tQuery = 'eminem';
    const tArtistModel = ArtistModel(id: 1, name: 'Eminem', imageUrl: 'url');
    const tAlbumModel =
        AlbumModel(id: 1, title: 'The Eminem Show', coverUrl: 'url');
    const tTrackModel = TrackModel(
      id: 1,
      title: 'Without Me',
      link: 'link',
      duration: 290,
      previewUrl: 'preview',
      artist: tArtistModel,
      album: tAlbumModel,
    );
    final tTrackModelList = [tTrackModel];
    // Now this line uses the REAL mapper from the app's source code,
    // ensuring type consistency.
    final tTrackEntityList =
        tTrackModelList.map((model) => model.toEntity()).toList();

    test(
      'should return Success with List<TrackEntity> when the call to remote data source is successful',
      () async {
        // Arrange
        when(mockRemoteDataSource.searchTracks(query: anyNamed('query')))
            .thenAnswer((_) async => tTrackModelList);

        // Act
        final result = await repository.searchTracks(query: tQuery);

        // Assert
        verify(mockRemoteDataSource.searchTracks(query: tQuery));
        verifyNoMoreInteractions(mockRemoteDataSource);
        
        // This comparison will now succeed because the types match perfectly.
        expect(
            result, equals(Success<List<TrackEntity>, AppException>(tTrackEntityList)));
      },
    );

    test(
      'should return Failure with a ServerException when the call to remote data source is unsuccessful',
      () async {
        // Arrange
        const tServerException = ServerException(message: 'API Error');
        when(mockRemoteDataSource.searchTracks(query: anyNamed('query')))
            .thenThrow(tServerException);

        // Act
        final result = await repository.searchTracks(query: tQuery);

        // Assert
        verify(mockRemoteDataSource.searchTracks(query: tQuery));
        verifyNoMoreInteractions(mockRemoteDataSource);
        
        expect(result,
            equals(Failure<List<TrackEntity>, AppException>(tServerException)));
      },
    );

    test(
      'should return Failure with a NetworkException when the device has no internet connection',
      () async {
        // Arrange
        const tNetworkException = NetworkException();
        when(mockRemoteDataSource.searchTracks(query: anyNamed('query')))
            .thenThrow(tNetworkException);

        // Act
        final result = await repository.searchTracks(query: tQuery);

        // Assert
        verify(mockRemoteDataSource.searchTracks(query: tQuery));
        verifyNoMoreInteractions(mockRemoteDataSource);
        
        expect(result,
            equals(Failure<List<TrackEntity>, AppException>(tNetworkException)));
      },
    );
  });
}