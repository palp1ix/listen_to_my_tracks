import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/data/datasources/music_remote_datasource.dart';
import 'package:listen_to_my_tracks/domain/entities/album.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/data/models/album/album_model.dart';
import 'package:listen_to_my_tracks/data/models/artist/artist_model.dart';
import 'package:listen_to_my_tracks/data/models/track/track_model.dart';
import 'package:listen_to_my_tracks/data/repositories/music_repository_impl.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'music_repository_impl_test.mocks.dart';

// This annotation tells the build_runner to generate a mock class
// for MusicRemoteDataSource in a file named `music_repository_impl_test.mocks.dart`.
@GenerateMocks([MusicRemoteDataSource])
void main() {
  // Declare the variables needed for the tests.
  late MockMusicRemoteDataSource mockRemoteDataSource;
  late MusicRepositoryImpl repository;

  // The setUp function is called before each test.
  // It's the perfect place to initialize objects to ensure a clean state.
  setUp(() {
    mockRemoteDataSource = MockMusicRemoteDataSource();
    repository = MusicRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  // Group related tests for better organization.
  group('searchTracks', () {
    // Define test data. Using a 't' prefix is a common convention for test variables.
    const tQuery = 'eminem';
    const tArtistModel = ArtistModel(id: 1, name: 'Eminem', imageUrl: 'url');
    const tAlbumModel = AlbumModel(id: 1, title: 'The Eminem Show', coverUrl: 'url');
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
    // We also prepare the expected entity, which our repository should return.
    final tTrackEntityList = tTrackModelList
        .map((model) => model.toEntity()) // This implicitly tests the mapper
        .toList();

    test(
      'should return Success with List<TrackEntity> when the call to remote data source is successful',
      () async {
        // Arrange: Set up the mock to return a successful response.
        // `when` configures the mock's behavior. `thenAnswer` provides the response.
        when(mockRemoteDataSource.searchTracks(query: anyNamed('query')))
            .thenAnswer((_) async => tTrackModelList);

        // Act: Call the method being tested.
        final result = await repository.searchTracks(query: tQuery);

        // Assert: Verify the outcome.
        // Check that the data source method was called with the correct query.
        verify(mockRemoteDataSource.searchTracks(query: tQuery));
        // Ensure no other methods on the mock were called.
        verifyNoMoreInteractions(mockRemoteDataSource);
        
        // The result should be a Success containing our expected entity list.
        // `Equatable` allows for a direct comparison of the lists.
        expect(result, equals(Success<List<TrackEntity>, AppException>(tTrackEntityList)));
      },
    );

    test(
      'should return Failure with a ServerException when the call to remote data source is unsuccessful',
      () async {
        // Arrange: Set up the mock to throw a ServerException.
        const tServerException = ServerException(message: 'API Error');
        when(mockRemoteDataSource.searchTracks(query: anyNamed('query')))
            .thenThrow(tServerException);

        // Act: Call the method.
        final result = await repository.searchTracks(query: tQuery);

        // Assert: Verify the outcome.
        verify(mockRemoteDataSource.searchTracks(query: tQuery));
        verifyNoMoreInteractions(mockRemoteDataSource);
        
        // The result should be a Failure wrapping the same exception.
        expect(result, equals(Failure<List<TrackEntity>, AppException>(tServerException)));
      },
    );

    test(
      'should return Failure with a NetworkException when the device has no internet connection',
      () async {
        // Arrange: Set up the mock to throw a NetworkException.
        const tNetworkException = NetworkException();
        when(mockRemoteDataSource.searchTracks(query: anyNamed('query')))
            .thenThrow(tNetworkException);

        // Act
        final result = await repository.searchTracks(query: tQuery);

        // Assert
        verify(mockRemoteDataSource.searchTracks(query: tQuery));
        verifyNoMoreInteractions(mockRemoteDataSource);
        
        // The result should be a Failure wrapping the NetworkException.
        expect(result, equals(Failure<List<TrackEntity>, AppException>(tNetworkException)));
      },
    );
  });
}

// Extension to map TrackModel to TrackEntity for testing purposes.
// This is needed because the original mappers are not accessible in the test scope directly.
extension on TrackModel {
  TrackEntity toEntity() {
    return TrackEntity(
      id: id,
      title: title,
      link: link,
      duration: Duration(seconds: duration),
      previewUrl: previewUrl,
      artist: Artist(id: artist.id, name: artist.name, imageUrl: artist.imageUrl),
      album: Album(id: album.id, title: album.title, coverUrl: album.coverUrl),
    );
  }
}

// Helper entity classes for the extension, mimicking the domain entities.
class Artist extends ArtistEntity {
  const Artist({required super.id, required super.name, required super.imageUrl});
}

class Album extends AlbumEntity {
  const Album({required super.id, required super.title, required super.coverUrl});
}