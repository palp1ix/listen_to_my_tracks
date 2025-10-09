import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/domain/entities/album.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/domain/repositories/music_repository.dart';
import 'package:listen_to_my_tracks/features/home/bloc/home_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([MusicRepository])
void main() {
  group('HomeBloc', () {
    late MockMusicRepository mockMusicRepository;
    late HomeBloc homeBloc;

    // Provide dummy values for Mockito
    provideDummy<Result<List<TrackEntity>, AppException>>(
      const Success<List<TrackEntity>, AppException>([]),
    );
    provideDummy<Result<void, AppException>>(
      const Success<void, AppException>(null),
    );

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
      homeBloc = HomeBloc(mockMusicRepository);
    });

    tearDown(() {
      homeBloc.close();
    });

    test('initial state should be HomeInitial', () {
      expect(homeBloc.state, equals(HomeInitial()));
    });

    group('HomeScreenStarted', () {
      blocTest<HomeBloc, HomeState>(
        'should emit HomeDataLoading then HomeDataLoaded when getChart succeeds',
        build: () {
          when(mockMusicRepository.getChart())
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([tTrackEntity]));
          return homeBloc;
        },
        act: (bloc) => bloc.add(const HomeScreenStarted()),
        expect: () => [
          HomeDataLoading(),
          const HomeDataLoaded([tTrackEntity]),
        ],
        verify: (_) {
          verify(mockMusicRepository.getChart()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'should emit HomeDataLoading then HomeDataLoaded with empty list when no chart data',
        build: () {
          when(mockMusicRepository.getChart())
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          return homeBloc;
        },
        act: (bloc) => bloc.add(const HomeScreenStarted()),
        expect: () => [
          HomeDataLoading(),
          const HomeDataLoaded([]),
        ],
        verify: (_) {
          verify(mockMusicRepository.getChart()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'should emit HomeDataLoading then HomeDataLoaded with multiple tracks',
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
          
          when(mockMusicRepository.getChart())
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([tTrackEntity, tTrackEntity]));
          return homeBloc;
        },
        act: (bloc) => bloc.add(const HomeScreenStarted()),
        expect: () => [
          HomeDataLoading(),
          const HomeDataLoaded([tTrackEntity, tTrackEntity]),
        ],
        verify: (_) {
          verify(mockMusicRepository.getChart()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'should emit HomeDataLoading then HomeDataError when getChart fails with ServerException',
        build: () {
          when(mockMusicRepository.getChart())
              .thenAnswer((_) async => const Failure<List<TrackEntity>, AppException>(
                ServerException(message: 'Server error'),
              ));
          return homeBloc;
        },
        act: (bloc) => bloc.add(const HomeScreenStarted()),
        expect: () => [
          HomeDataLoading(),
          const HomeDataError('Server error'),
        ],
        verify: (_) {
          verify(mockMusicRepository.getChart()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'should emit HomeDataLoading then HomeDataError when getChart fails with NetworkException',
        build: () {
          when(mockMusicRepository.getChart())
              .thenAnswer((_) async => const Failure<List<TrackEntity>, AppException>(
                NetworkException(),
              ));
          return homeBloc;
        },
        act: (bloc) => bloc.add(const HomeScreenStarted()),
        expect: () => [
          HomeDataLoading(),
          const HomeDataError('No internet connection. Please check your network.'),
        ],
        verify: (_) {
          verify(mockMusicRepository.getChart()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'should emit HomeDataLoading then HomeDataError when getChart fails with AppException',
        build: () {
          when(mockMusicRepository.getChart())
              .thenAnswer((_) async => const Failure<List<TrackEntity>, AppException>(
                AppException(message: 'Unknown error'),
              ));
          return homeBloc;
        },
        act: (bloc) => bloc.add(const HomeScreenStarted()),
        expect: () => [
          HomeDataLoading(),
          const HomeDataError('Unknown error'),
        ],
        verify: (_) {
          verify(mockMusicRepository.getChart()).called(1);
        },
      );
    });

    group('Multiple events', () {
      blocTest<HomeBloc, HomeState>(
        'should handle multiple HomeScreenStarted events correctly',
        build: () {
          when(mockMusicRepository.getChart())
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([tTrackEntity]));
          return homeBloc;
        },
        act: (bloc) {
          bloc.add(const HomeScreenStarted());
          bloc.add(const HomeScreenStarted());
          bloc.add(const HomeScreenStarted());
        },
        expect: () => [
          HomeDataLoading(),
          const HomeDataLoaded([tTrackEntity]),
          HomeDataLoading(),
          const HomeDataLoaded([tTrackEntity]),
          HomeDataLoading(),
          const HomeDataLoaded([tTrackEntity]),
        ],
        verify: (_) {
          verify(mockMusicRepository.getChart()).called(3);
        },
      );
    });
  });
}
