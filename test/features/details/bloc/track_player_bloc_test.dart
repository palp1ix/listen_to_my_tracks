import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/domain/entities/album.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/domain/services/audio_player_service.dart';
import 'package:listen_to_my_tracks/features/details/bloc/track_player_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'track_player_bloc_test.mocks.dart';

@GenerateMocks([AudioPlayerService])
void main() {
  group('TrackPlayerBloc', () {
    late MockAudioPlayerService mockAudioPlayerService;
    late TrackPlayerBloc trackPlayerBloc;

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
      mockAudioPlayerService = MockAudioPlayerService();
      trackPlayerBloc = TrackPlayerBloc(audioPlayerService: mockAudioPlayerService);
    });

    tearDown(() {
      trackPlayerBloc.close();
    });

    test('initial state should be TrackPlayerState with initial status', () {
      expect(trackPlayerBloc.state, equals(const TrackPlayerState()));
      expect(trackPlayerBloc.state.status, equals(PlayerStatus.initial));
      expect(trackPlayerBloc.state.totalDuration, equals(Duration.zero));
      expect(trackPlayerBloc.state.currentPosition, equals(Duration.zero));
      expect(trackPlayerBloc.state.errorMessage, isNull);
    });

    group('LoadTrack', () {
      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should emit loading status when loading track',
        build: () {
          when(mockAudioPlayerService.load(any))
              .thenAnswer((_) async {});
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const LoadTrack(track: tTrackEntity)),
        expect: () => [
          const TrackPlayerState(status: PlayerStatus.loading),
        ],
        verify: (_) {
          verify(mockAudioPlayerService.load(tTrackEntity.previewUrl)).called(1);
        },
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should emit error status when loading fails',
        build: () {
          when(mockAudioPlayerService.load(any))
              .thenThrow(Exception('Network error'));
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const LoadTrack(track: tTrackEntity)),
        expect: () => [
          const TrackPlayerState(
            status: PlayerStatus.error,
            errorMessage: 'Exception: Network error',
          ),
        ],
        verify: (_) {
          verify(mockAudioPlayerService.load(tTrackEntity.previewUrl)).called(1);
        },
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should handle empty preview URL',
        build: () {
          const trackWithEmptyUrl = TrackEntity(
            id: 1,
            title: 'Without Me',
            link: 'https://example.com/track',
            duration: Duration(seconds: 290),
            previewUrl: '',
            artist: tArtistEntity,
            album: tAlbumEntity,
          );
          
          when(mockAudioPlayerService.load(any))
              .thenAnswer((_) async {});
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const LoadTrack(track: TrackEntity(
          id: 1,
          title: 'Without Me',
          link: 'https://example.com/track',
          duration: Duration(seconds: 290),
          previewUrl: '',
          artist: tArtistEntity,
          album: tAlbumEntity,
        ))),
        expect: () => [
          const TrackPlayerState(status: PlayerStatus.loading),
        ],
        verify: (_) {
          verify(mockAudioPlayerService.load('')).called(1);
        },
      );
    });

    group('PlayRequested', () {
      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should call play on audio service',
        build: () {
          when(mockAudioPlayerService.play())
              .thenAnswer((_) async {});
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(PlayRequested()),
        expect: () => [],
        verify: (_) {
          verify(mockAudioPlayerService.play()).called(1);
        },
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should handle play errors gracefully',
        build: () {
          when(mockAudioPlayerService.play())
              .thenThrow(Exception('Play error'));
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(PlayRequested()),
        expect: () => [],
        verify: (_) {
          verify(mockAudioPlayerService.play()).called(1);
        },
      );
    });

    group('PauseRequested', () {
      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should call pause on audio service',
        build: () {
          when(mockAudioPlayerService.pause())
              .thenAnswer((_) async {});
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(PauseRequested()),
        expect: () => [],
        verify: (_) {
          verify(mockAudioPlayerService.pause()).called(1);
        },
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should handle pause errors gracefully',
        build: () {
          when(mockAudioPlayerService.pause())
              .thenThrow(Exception('Pause error'));
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(PauseRequested()),
        expect: () => [],
        verify: (_) {
          verify(mockAudioPlayerService.pause()).called(1);
        },
      );
    });

    group('SeekRequested', () {
      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should call seek on audio service with correct position',
        build: () {
          when(mockAudioPlayerService.seek(any))
              .thenAnswer((_) async {});
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const SeekRequested(Duration(seconds: 30))),
        expect: () => [],
        verify: (_) {
          verify(mockAudioPlayerService.seek(const Duration(seconds: 30))).called(1);
        },
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should handle seek to zero position',
        build: () {
          when(mockAudioPlayerService.seek(any))
              .thenAnswer((_) async {});
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const SeekRequested(Duration.zero)),
        expect: () => [],
        verify: (_) {
          verify(mockAudioPlayerService.seek(Duration.zero)).called(1);
        },
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should handle seek to end position',
        build: () {
          when(mockAudioPlayerService.seek(any))
              .thenAnswer((_) async {});
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const SeekRequested(Duration(hours: 1))),
        expect: () => [],
        verify: (_) {
          verify(mockAudioPlayerService.seek(const Duration(hours: 1))).called(1);
        },
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should handle seek errors gracefully',
        build: () {
          when(mockAudioPlayerService.seek(any))
              .thenThrow(Exception('Seek error'));
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const SeekRequested(Duration(seconds: 30))),
        expect: () => [],
        verify: (_) {
          verify(mockAudioPlayerService.seek(const Duration(seconds: 30))).called(1);
        },
      );
    });

    group('Player status changes', () {
      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should update status when player status changes to playing',
        build: () {
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(PlayRequested()),
        expect: () => [
          const TrackPlayerState(status: PlayerStatus.playing),
        ],
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should update status when player status changes to paused',
        build: () {
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(PauseRequested()),
        expect: () => [
          const TrackPlayerState(status: PlayerStatus.paused),
        ],
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should update status when player status changes to completed',
        build: () {
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(PlayRequested()),
        expect: () => [
          const TrackPlayerState(status: PlayerStatus.completed),
        ],
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should update status when player status changes to error',
        build: () {
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(PlayRequested()),
        expect: () => [
          const TrackPlayerState(status: PlayerStatus.error),
        ],
      );
    });

    group('Player position changes', () {
      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should update current position when player position changes',
        build: () {
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const SeekRequested(Duration(seconds: 30))),
        expect: () => [
          const TrackPlayerState(currentPosition: Duration(seconds: 30)),
        ],
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should update current position to zero',
        build: () {
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const SeekRequested(Duration.zero)),
        expect: () => [
          const TrackPlayerState(currentPosition: Duration.zero),
        ],
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should update current position to large value',
        build: () {
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const SeekRequested(Duration(hours: 1))),
        expect: () => [
          const TrackPlayerState(currentPosition: Duration(hours: 1)),
        ],
      );
    });

    group('Player duration changes', () {
      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should update total duration when player duration changes',
        build: () {
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const LoadTrack(track: tTrackEntity)),
        expect: () => [
          const TrackPlayerState(totalDuration: Duration(seconds: 290)),
        ],
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should update total duration to zero',
        build: () {
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const LoadTrack(track: tTrackEntity)),
        expect: () => [
          const TrackPlayerState(totalDuration: Duration.zero),
        ],
      );

      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should update total duration to large value',
        build: () {
          return trackPlayerBloc;
        },
        act: (bloc) => bloc.add(const LoadTrack(track: tTrackEntity)),
        expect: () => [
          const TrackPlayerState(totalDuration: Duration(hours: 2)),
        ],
      );
    });

    group('Multiple events', () {
      blocTest<TrackPlayerBloc, TrackPlayerState>(
        'should handle multiple events correctly',
        build: () {
          when(mockAudioPlayerService.load(any))
              .thenAnswer((_) async {});
          when(mockAudioPlayerService.play())
              .thenAnswer((_) async {});
          when(mockAudioPlayerService.pause())
              .thenAnswer((_) async {});
          when(mockAudioPlayerService.seek(any))
              .thenAnswer((_) async {});
          return trackPlayerBloc;
        },
        act: (bloc) {
          bloc.add(const LoadTrack(track: tTrackEntity));
          bloc.add(PlayRequested());
          bloc.add(PauseRequested());
          bloc.add(const SeekRequested(Duration(seconds: 30)));
          bloc.add(PlayRequested());
          bloc.add(const SeekRequested(Duration(seconds: 30)));
          bloc.add(const LoadTrack(track: tTrackEntity));
        },
        expect: () => [
          const TrackPlayerState(status: PlayerStatus.loading),
          const TrackPlayerState(status: PlayerStatus.playing),
          const TrackPlayerState(
            status: PlayerStatus.playing,
            currentPosition: Duration(seconds: 30),
          ),
          const TrackPlayerState(
            status: PlayerStatus.playing,
            currentPosition: Duration(seconds: 30),
            totalDuration: Duration(seconds: 290),
          ),
        ],
        verify: (_) {
          verify(mockAudioPlayerService.load(tTrackEntity.previewUrl)).called(1);
          verify(mockAudioPlayerService.play()).called(1);
          verify(mockAudioPlayerService.pause()).called(1);
          verify(mockAudioPlayerService.seek(const Duration(seconds: 30))).called(1);
        },
      );
    });
  });
}
