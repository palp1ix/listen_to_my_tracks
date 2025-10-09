import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/domain/entities/album.dart';
import 'package:listen_to_my_tracks/domain/entities/artist.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/domain/repositories/music_repository.dart';
import 'package:listen_to_my_tracks/domain/repositories/search_history_repository.dart';
import 'package:listen_to_my_tracks/features/search/bloc/search_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([MusicRepository, SearchHistoryRepository])
void main() {
  group('SearchBloc', () {
    late MockMusicRepository mockMusicRepository;
    late MockSearchHistoryRepository mockSearchHistoryRepository;
    late SearchBloc searchBloc;

    // Provide dummy values for Mockito
    provideDummy<Result<List<TrackEntity>, AppException>>(
      const Success<List<TrackEntity>, AppException>([]),
    );
    provideDummy<Result<List<String>, AppException>>(
      const Success<List<String>, AppException>([]),
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
      mockSearchHistoryRepository = MockSearchHistoryRepository();
      searchBloc = SearchBloc(mockMusicRepository, mockSearchHistoryRepository);
    });

    tearDown(() {
      searchBloc.close();
    });

    test('initial state should be SearchInitial', () {
      expect(searchBloc.state, equals(const SearchInitial()));
    });

    group('HistoryRequested', () {
      blocTest<SearchBloc, SearchState>(
        'should emit SearchInitial with history when getSearchHistory succeeds',
        build: () {
          when(mockSearchHistoryRepository.getSearchHistory())
              .thenAnswer((_) async => const Success<List<String>, AppException>(['eminem', 'drake']));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const HistoryRequested()),
        expect: () => [
          const SearchInitial(history: ['eminem', 'drake']),
        ],
        verify: (_) {
          verify(mockSearchHistoryRepository.getSearchHistory()).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit SearchInitial with empty history when getSearchHistory fails',
        build: () {
          when(mockSearchHistoryRepository.getSearchHistory())
              .thenAnswer((_) async => const Failure<List<String>, AppException>(
                AppException(message: 'Database error'),
              ));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const HistoryRequested()),
        expect: () => [
          const SearchInitial(history: []),
        ],
        verify: (_) {
          verify(mockSearchHistoryRepository.getSearchHistory()).called(1);
        },
      );
    });

    group('SearchRequested', () {
      const tQuery = 'eminem';

      blocTest<SearchBloc, SearchState>(
        'should emit SearchLoading then SearchSuccess when search succeeds',
        build: () {
          when(mockMusicRepository.searchTracks(query: anyNamed('query')))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([tTrackEntity]));
          when(mockSearchHistoryRepository.saveSearchTerm(term: anyNamed('term')))
              .thenAnswer((_) async => const Success<void, AppException>(null));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchRequested(tQuery)),
        expect: () => [
          const SearchLoading(tQuery),
          const SearchSuccess([tTrackEntity]),
        ],
        verify: (_) {
          verify(mockMusicRepository.searchTracks(query: tQuery)).called(1);
          verify(mockSearchHistoryRepository.saveSearchTerm(term: tQuery)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit SearchLoading then SearchSuccess with empty list when no results found',
        build: () {
          when(mockMusicRepository.searchTracks(query: anyNamed('query')))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          when(mockSearchHistoryRepository.saveSearchTerm(term: anyNamed('term')))
              .thenAnswer((_) async => const Success<void, AppException>(null));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchRequested(tQuery)),
        expect: () => [
          const SearchLoading(tQuery),
          const SearchSuccess([]),
        ],
        verify: (_) {
          verify(mockMusicRepository.searchTracks(query: tQuery)).called(1);
          verify(mockSearchHistoryRepository.saveSearchTerm(term: tQuery)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit SearchLoading then SearchFailure when search fails',
        build: () {
          when(mockMusicRepository.searchTracks(query: anyNamed('query')))
              .thenAnswer((_) async => const Failure<List<TrackEntity>, AppException>(
                ServerException(message: 'Server error'),
              ));
          when(mockSearchHistoryRepository.saveSearchTerm(term: anyNamed('term')))
              .thenAnswer((_) async => const Success<void, AppException>(null));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchRequested(tQuery)),
        expect: () => [
          const SearchLoading(tQuery),
          const SearchFailure('Server error'),
        ],
        verify: (_) {
          verify(mockMusicRepository.searchTracks(query: tQuery)).called(1);
          verify(mockSearchHistoryRepository.saveSearchTerm(term: tQuery)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should emit SearchLoading then SearchFailure when network error occurs',
        build: () {
          when(mockMusicRepository.searchTracks(query: anyNamed('query')))
              .thenAnswer((_) async => const Failure<List<TrackEntity>, AppException>(
                NetworkException(),
              ));
          when(mockSearchHistoryRepository.saveSearchTerm(term: anyNamed('term')))
              .thenAnswer((_) async => const Success<void, AppException>(null));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchRequested(tQuery)),
        expect: () => [
          const SearchLoading(tQuery),
          const SearchFailure('No internet connection. Please check your network.'),
        ],
        verify: (_) {
          verify(mockMusicRepository.searchTracks(query: tQuery)).called(1);
          verify(mockSearchHistoryRepository.saveSearchTerm(term: tQuery)).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should handle empty query',
        build: () {
          when(mockMusicRepository.searchTracks(query: anyNamed('query')))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          when(mockSearchHistoryRepository.saveSearchTerm(term: anyNamed('term')))
              .thenAnswer((_) async => const Success<void, AppException>(null));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchRequested('')),
        expect: () => [
          const SearchLoading(''),
          const SearchSuccess([]),
        ],
        verify: (_) {
          verify(mockMusicRepository.searchTracks(query: '')).called(1);
          verify(mockSearchHistoryRepository.saveSearchTerm(term: '')).called(1);
        },
      );

      blocTest<SearchBloc, SearchState>(
        'should handle query with special characters',
        build: () {
          const specialQuery = 'eminem & dr. dre';
          when(mockMusicRepository.searchTracks(query: anyNamed('query')))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          when(mockSearchHistoryRepository.saveSearchTerm(term: anyNamed('term')))
              .thenAnswer((_) async => const Success<void, AppException>(null));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchRequested('eminem & dr. dre')),
        expect: () => [
          const SearchLoading('eminem & dr. dre'),
          const SearchSuccess([]),
        ],
        verify: (_) {
          verify(mockMusicRepository.searchTracks(query: 'eminem & dr. dre')).called(1);
          verify(mockSearchHistoryRepository.saveSearchTerm(term: 'eminem & dr. dre')).called(1);
        },
      );
    });

    group('SearchCleared', () {
      blocTest<SearchBloc, SearchState>(
        'should emit SearchInitial with empty history when SearchCleared is triggered',
        build: () {
          when(mockSearchHistoryRepository.getSearchHistory())
              .thenAnswer((_) async => const Success<List<String>, AppException>([]));
          return searchBloc;
        },
        act: (bloc) => bloc.add(const SearchCleared()),
        expect: () => [
          const SearchInitial(history: []),
        ],
        verify: (_) {
          verify(mockSearchHistoryRepository.getSearchHistory()).called(1);
        },
      );
    });

    group('Multiple events', () {
      blocTest<SearchBloc, SearchState>(
        'should handle multiple search requests correctly',
        build: () {
          when(mockMusicRepository.searchTracks(query: anyNamed('query')))
              .thenAnswer((_) async => const Success<List<TrackEntity>, AppException>([]));
          when(mockSearchHistoryRepository.saveSearchTerm(term: anyNamed('term')))
              .thenAnswer((_) async => const Success<void, AppException>(null));
          return searchBloc;
        },
        act: (bloc) {
          bloc.add(const SearchRequested('eminem'));
          bloc.add(const SearchRequested('drake'));
          bloc.add(const SearchRequested('kendrick'));
        },
        expect: () => [
          const SearchLoading('eminem'),
          const SearchSuccess([]),
          const SearchLoading('drake'),
          const SearchSuccess([]),
          const SearchLoading('kendrick'),
          const SearchSuccess([]),
        ],
        verify: (_) {
          verify(mockMusicRepository.searchTracks(query: 'eminem')).called(1);
          verify(mockMusicRepository.searchTracks(query: 'drake')).called(1);
          verify(mockMusicRepository.searchTracks(query: 'kendrick')).called(1);
          verify(mockSearchHistoryRepository.saveSearchTerm(term: 'eminem')).called(1);
          verify(mockSearchHistoryRepository.saveSearchTerm(term: 'drake')).called(1);
          verify(mockSearchHistoryRepository.saveSearchTerm(term: 'kendrick')).called(1);
        },
      );
    });
  });
}
