import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/domain/entities/album.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/domain/repositories/music_repository.dart';
import 'package:listen_to_my_tracks/features/artist_tracks/bloc/artist_tracks_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'artist_tracks_bloc_test.mocks.dart';

@GenerateMocks([MusicRepository])
void main() {
  group('ArtistTracksBloc', () {
    late MockMusicRepository mockMusicRepository;
    late ArtistTracksBloc artistTracksBloc;

    // Provide dummy values for Mockito
    provideDummy<Result<List<TrackEntity>, AppException>>(
      const Success<List<TrackEntity>, AppException>([]),
    );
    provideDummy<Result<void, AppException>>(
      const Success<void, AppException>(null),
    );

    const tArtistId = 1;
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

    setUp(() {
      mockMusicRepository = MockMusicRepository();
      artistTracksBloc = ArtistTracksBloc(mockMusicRepository);
    });

    tearDown(() {
      artistTracksBloc.close();
    });

    test('initial state should be ArtistTracksInitial', () {
      expect(artistTracksBloc.state, equals(ArtistTracksInitial()));
    });

    group('LoadArtistTracks', () {
      blocTest<ArtistTracksBloc, ArtistTracksState>(
        'should emit ArtistTracksLoading then ArtistTracksLoaded when getArtistTracks succeeds',
        build: () {
          when(mockMusicRepository.getArtistTracks(tArtistId))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([tTrackEntity]));
          return artistTracksBloc;
        },
        act: (bloc) => bloc.add(const LoadArtistTracks(tArtistId)),
        expect: () => [
          ArtistTracksLoading(),
          const ArtistTracksLoaded([tTrackEntity], tArtistId),
        ],
        verify: (_) {
          verify(mockMusicRepository.getArtistTracks(tArtistId)).called(1);
        },
      );

      blocTest<ArtistTracksBloc, ArtistTracksState>(
        'should emit ArtistTracksLoading then ArtistTracksLoaded with empty list when no tracks found',
        build: () {
          when(mockMusicRepository.getArtistTracks(tArtistId))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          return artistTracksBloc;
        },
        act: (bloc) => bloc.add(const LoadArtistTracks(tArtistId)),
        expect: () => [
          ArtistTracksLoading(),
          const ArtistTracksLoaded([], tArtistId),
        ],
        verify: (_) {
          verify(mockMusicRepository.getArtistTracks(tArtistId)).called(1);
        },
      );

      blocTest<ArtistTracksBloc, ArtistTracksState>(
        'should emit ArtistTracksLoading then ArtistTracksLoaded with multiple tracks',
        build: () {
          const tTrackEntity2 = TrackEntity(
            id: 2,
            title: 'Lose Yourself',
            link: 'https://example.com/track2',
            duration: Duration(seconds: 180),
            previewUrl: 'https://example.com/preview2.mp3',
            artist: tArtistEntity,
            album: tAlbumEntity,
          );
          
          when(mockMusicRepository.getArtistTracks(tArtistId))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([tTrackEntity, tTrackEntity2]));
          return artistTracksBloc;
        },
        act: (bloc) => bloc.add(const LoadArtistTracks(tArtistId)),
        expect: () => [
          ArtistTracksLoading(),
          const ArtistTracksLoaded([tTrackEntity, tTrackEntity], tArtistId),
        ],
        verify: (_) {
          verify(mockMusicRepository.getArtistTracks(tArtistId)).called(1);
        },
      );

      blocTest<ArtistTracksBloc, ArtistTracksState>(
        'should emit ArtistTracksLoading then ArtistTracksError when getArtistTracks fails with ServerException',
        build: () {
          when(mockMusicRepository.getArtistTracks(tArtistId))
              .thenAnswer((_) async => const Failure<List<TrackEntity>, AppException>(
                ServerException(message: 'Server error'),
              ));
          return artistTracksBloc;
        },
        act: (bloc) => bloc.add(const LoadArtistTracks(tArtistId)),
        expect: () => [
          ArtistTracksLoading(),
          const ArtistTracksError('Server error', tArtistId),
        ],
        verify: (_) {
          verify(mockMusicRepository.getArtistTracks(tArtistId)).called(1);
        },
      );

      blocTest<ArtistTracksBloc, ArtistTracksState>(
        'should emit ArtistTracksLoading then ArtistTracksError when getArtistTracks fails with NetworkException',
        build: () {
          when(mockMusicRepository.getArtistTracks(tArtistId))
              .thenAnswer((_) async => const Failure<List<TrackEntity>, AppException>(
                NetworkException(),
              ));
          return artistTracksBloc;
        },
        act: (bloc) => bloc.add(const LoadArtistTracks(tArtistId)),
        expect: () => [
          ArtistTracksLoading(),
          const ArtistTracksError('No internet connection. Please check your network.', tArtistId),
        ],
        verify: (_) {
          verify(mockMusicRepository.getArtistTracks(tArtistId)).called(1);
        },
      );

      blocTest<ArtistTracksBloc, ArtistTracksState>(
        'should emit ArtistTracksLoading then ArtistTracksError when getArtistTracks fails with AppException',
        build: () {
          when(mockMusicRepository.getArtistTracks(tArtistId))
              .thenAnswer((_) async => const Failure<List<TrackEntity>, AppException>(
                AppException(message: 'Unknown error'),
              ));
          return artistTracksBloc;
        },
        act: (bloc) => bloc.add(const LoadArtistTracks(tArtistId)),
        expect: () => [
          ArtistTracksLoading(),
          const ArtistTracksError('Unknown error', tArtistId),
        ],
        verify: (_) {
          verify(mockMusicRepository.getArtistTracks(tArtistId)).called(1);
        },
      );

      blocTest<ArtistTracksBloc, ArtistTracksState>(
        'should handle different artist IDs',
        build: () {
          const differentArtistId = 2;
          when(mockMusicRepository.getArtistTracks(tArtistId))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          return artistTracksBloc;
        },
        act: (bloc) => bloc.add(const LoadArtistTracks(2)),
        expect: () => [
          ArtistTracksLoading(),
          const ArtistTracksLoaded([], 2),
        ],
        verify: (_) {
          verify(mockMusicRepository.getArtistTracks(2)).called(1);
        },
      );

      blocTest<ArtistTracksBloc, ArtistTracksState>(
        'should handle zero artist ID',
        build: () {
          when(mockMusicRepository.getArtistTracks(tArtistId))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          return artistTracksBloc;
        },
        act: (bloc) => bloc.add(const LoadArtistTracks(0)),
        expect: () => [
          ArtistTracksLoading(),
          const ArtistTracksLoaded([], 0),
        ],
        verify: (_) {
          verify(mockMusicRepository.getArtistTracks(0)).called(1);
        },
      );

      blocTest<ArtistTracksBloc, ArtistTracksState>(
        'should handle negative artist ID',
        build: () {
          when(mockMusicRepository.getArtistTracks(tArtistId))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          return artistTracksBloc;
        },
        act: (bloc) => bloc.add(const LoadArtistTracks(-1)),
        expect: () => [
          ArtistTracksLoading(),
          const ArtistTracksLoaded([], -1),
        ],
        verify: (_) {
          verify(mockMusicRepository.getArtistTracks(-1)).called(1);
        },
      );
    });

    group('Multiple events', () {
      blocTest<ArtistTracksBloc, ArtistTracksState>(
        'should handle multiple LoadArtistTracks events correctly',
        build: () {
          when(mockMusicRepository.getArtistTracks(tArtistId))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          return artistTracksBloc;
        },
        act: (bloc) {
          bloc.add(const LoadArtistTracks(1));
          bloc.add(const LoadArtistTracks(2));
          bloc.add(const LoadArtistTracks(3));
        },
        expect: () => [
          ArtistTracksLoading(),
          const ArtistTracksLoaded([], 1),
          ArtistTracksLoading(),
          const ArtistTracksLoaded([], 2),
          ArtistTracksLoading(),
          const ArtistTracksLoaded([], 3),
        ],
        verify: (_) {
          verify(mockMusicRepository.getArtistTracks(1)).called(1);
          verify(mockMusicRepository.getArtistTracks(2)).called(1);
          verify(mockMusicRepository.getArtistTracks(3)).called(1);
        },
      );

      blocTest<ArtistTracksBloc, ArtistTracksState>(
        'should handle mixed success and failure events',
        build: () {
          when(mockMusicRepository.getArtistTracks(1))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          when(mockMusicRepository.getArtistTracks(2))
              .thenAnswer((_) async => const Failure<List<TrackEntity>, AppException>(
                ServerException(message: 'Server error'),
              ));
          when(mockMusicRepository.getArtistTracks(3))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          return artistTracksBloc;
        },
        act: (bloc) {
          bloc.add(const LoadArtistTracks(1));
          bloc.add(const LoadArtistTracks(2));
          bloc.add(const LoadArtistTracks(3));
        },
        expect: () => [
          ArtistTracksLoading(),
          const ArtistTracksLoaded([], 1),
          ArtistTracksLoading(),
          const ArtistTracksError('Server error', 2),
          ArtistTracksLoading(),
          const ArtistTracksLoaded([], 3),
        ],
        verify: (_) {
          verify(mockMusicRepository.getArtistTracks(1)).called(1);
          verify(mockMusicRepository.getArtistTracks(2)).called(1);
          verify(mockMusicRepository.getArtistTracks(3)).called(1);
        },
      );
    });
  });
}
