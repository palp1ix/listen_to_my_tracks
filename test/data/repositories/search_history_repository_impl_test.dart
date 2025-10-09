import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/data/datasources/search_history_local_datasource.dart';
import 'package:listen_to_my_tracks/data/repositories/search_history_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_history_repository_impl_test.mocks.dart';

@GenerateMocks([SearchHistoryLocalDataSource])
void main() {
  late MockSearchHistoryLocalDataSource mockLocalDataSource;
  late SearchHistoryRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockSearchHistoryLocalDataSource();
    repository = SearchHistoryRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('getSearchHistory', () {
    test('should return Success with List<String> when the call is successful', () async {
      // Arrange
      const tHistory = ['eminem', 'drake', 'kendrick'];
      when(mockLocalDataSource.getSearchHistory())
          .thenAnswer((_) async => tHistory);

      // Act
      final result = await repository.getSearchHistory();

      // Assert
      verify(mockLocalDataSource.getSearchHistory());
      verifyNoMoreInteractions(mockLocalDataSource);
      expect(result, equals(Success<List<String>, AppException>(tHistory)));
    });

    test('should return Success with empty list when no history exists', () async {
      // Arrange
      when(mockLocalDataSource.getSearchHistory())
          .thenAnswer((_) async => <String>[]);

      // Act
      final result = await repository.getSearchHistory();

      // Assert
      verify(mockLocalDataSource.getSearchHistory());
      verifyNoMoreInteractions(mockLocalDataSource);
      expect(result, equals(Success<List<String>, AppException>(<String>[])));
    });

      test('should return Failure with AppException when the call throws an exception', () async {
        // Arrange
        final tException = Exception('Database error');
      when(mockLocalDataSource.getSearchHistory())
          .thenThrow(tException);

      // Act
      final result = await repository.getSearchHistory();

      // Assert
      verify(mockLocalDataSource.getSearchHistory());
      verifyNoMoreInteractions(mockLocalDataSource);
      expect(result, isA<Failure<List<String>, AppException>>());
      expect((result as Failure).exception.message, 'Exception: Database error');
    });

    test('should return Failure with AppException when the call throws a specific error', () async {
      // Arrange
      const tError = 'SQLite error: database is locked';
      when(mockLocalDataSource.getSearchHistory())
          .thenThrow(tError);

      // Act
      final result = await repository.getSearchHistory();

      // Assert
      verify(mockLocalDataSource.getSearchHistory());
      verifyNoMoreInteractions(mockLocalDataSource);
      expect(result, isA<Failure<List<String>, AppException>>());
      expect((result as Failure).exception.message, tError);
    });
  });

  group('saveSearchTerm', () {
    test('should return Success when the call is successful', () async {
      // Arrange
      const tTerm = 'eminem';
      when(mockLocalDataSource.saveSearchTerm(any))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.saveSearchTerm(term: tTerm);

      // Assert
      verify(mockLocalDataSource.saveSearchTerm(tTerm));
      verifyNoMoreInteractions(mockLocalDataSource);
      expect(result, equals(Success<void, AppException>(null)));
    });

    test('should return Success when saving empty term', () async {
      // Arrange
      const tTerm = '';
      when(mockLocalDataSource.saveSearchTerm(any))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.saveSearchTerm(term: tTerm);

      // Assert
      verify(mockLocalDataSource.saveSearchTerm(tTerm));
      verifyNoMoreInteractions(mockLocalDataSource);
      expect(result, equals(Success<void, AppException>(null)));
    });

    test('should return Success when saving term with whitespace', () async {
      // Arrange
      const tTerm = '  eminem  ';
      when(mockLocalDataSource.saveSearchTerm(any))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.saveSearchTerm(term: tTerm);

      // Assert
      verify(mockLocalDataSource.saveSearchTerm(tTerm));
      verifyNoMoreInteractions(mockLocalDataSource);
      expect(result, equals(Success<void, AppException>(null)));
    });

    test('should return Success when saving special characters', () async {
      // Arrange
      const tTerm = 'eminem & dr. dre';
      when(mockLocalDataSource.saveSearchTerm(any))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.saveSearchTerm(term: tTerm);

      // Assert
      verify(mockLocalDataSource.saveSearchTerm(tTerm));
      verifyNoMoreInteractions(mockLocalDataSource);
      expect(result, equals(Success<void, AppException>(null)));
    });

      test('should return Failure with AppException when the call throws an exception', () async {
        // Arrange
        const tTerm = 'eminem';
        final tException = Exception('Database write error');
      when(mockLocalDataSource.saveSearchTerm(any))
          .thenThrow(tException);

      // Act
      final result = await repository.saveSearchTerm(term: tTerm);

      // Assert
      verify(mockLocalDataSource.saveSearchTerm(tTerm));
      verifyNoMoreInteractions(mockLocalDataSource);
      expect(result, isA<Failure<void, AppException>>());
      expect((result as Failure).exception.message, 'Exception: Database write error');
    });

    test('should return Failure with AppException when the call throws a specific error', () async {
      // Arrange
      const tTerm = 'eminem';
      const tError = 'SQLite error: disk is full';
      when(mockLocalDataSource.saveSearchTerm(any))
          .thenThrow(tError);

      // Act
      final result = await repository.saveSearchTerm(term: tTerm);

      // Assert
      verify(mockLocalDataSource.saveSearchTerm(tTerm));
      verifyNoMoreInteractions(mockLocalDataSource);
      expect(result, isA<Failure<void, AppException>>());
      expect((result as Failure).exception.message, tError);
    });

    test('should handle very long search terms', () async {
      // Arrange
      final tTerm = 'a' * 1000; // Very long term
      when(mockLocalDataSource.saveSearchTerm(any))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.saveSearchTerm(term: tTerm);

      // Assert
      verify(mockLocalDataSource.saveSearchTerm(tTerm));
      verifyNoMoreInteractions(mockLocalDataSource);
      expect(result, equals(Success<void, AppException>(null)));
    });
  });
}
