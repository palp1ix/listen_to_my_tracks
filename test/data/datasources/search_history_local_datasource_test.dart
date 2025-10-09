import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/data/datasources/search_history_local_datasource.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('SearchHistoryLocalDataSourceImpl', () {
    late SearchHistoryLocalDataSourceImpl dataSource;

    setUpAll(() {
      // Initialize FFI for testing
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() async {
      dataSource = SearchHistoryLocalDataSourceImpl();
      // Clear any existing data before each test
      await dataSource.clearSearchHistory();
    });

    tearDown(() async {
      // Clean up after each test
      await dataSource.clearSearchHistory();
    });

    group('saveSearchTerm', () {
      test('should save search term successfully', () async {
        const term = 'eminem';
        
        await dataSource.saveSearchTerm(term);
        
        final history = await dataSource.getSearchHistory();
        expect(history, contains(term));
      });

      test('should not save empty term', () async {
        await dataSource.saveSearchTerm('');
        
        final history = await dataSource.getSearchHistory();
        expect(history, isEmpty);
      });

      test('should not save whitespace-only term', () async {
        await dataSource.saveSearchTerm('   ');
        
        final history = await dataSource.getSearchHistory();
        expect(history, isEmpty);
      });

      test('should trim whitespace from term', () async {
        const term = '  eminem  ';
        const expectedTerm = 'eminem';
        
        await dataSource.saveSearchTerm(term);
        
        final history = await dataSource.getSearchHistory();
        expect(history, contains(expectedTerm));
        expect(history, isNot(contains(term)));
      });

      test('should replace existing term with same value', () async {
        const term = 'eminem';
        
        await dataSource.saveSearchTerm(term);
        await Future.delayed(const Duration(milliseconds: 10));
        await dataSource.saveSearchTerm(term);
        
        final history = await dataSource.getSearchHistory();
        expect(history.where((h) => h == term).length, 1);
      });

      test('should handle special characters in term', () async {
        const term = 'eminem & dr. dre';
        
        await dataSource.saveSearchTerm(term);
        
        final history = await dataSource.getSearchHistory();
        expect(history, contains(term));
      });

      test('should handle very long term', () async {
        final term = 'a' * 1000; // Very long term
        
        await dataSource.saveSearchTerm(term);
        
        final history = await dataSource.getSearchHistory();
        expect(history, contains(term));
      });
    });

    group('getSearchHistory', () {
      test('should return empty list when no history exists', () async {
        final history = await dataSource.getSearchHistory();
        expect(history, isEmpty);
      });

      test('should return search history in descending order by timestamp', () async {
        const term1 = 'eminem';
        const term2 = 'drake';
        const term3 = 'kendrick';
        
        await dataSource.saveSearchTerm(term1);
        await Future.delayed(const Duration(milliseconds: 10));
        await dataSource.saveSearchTerm(term2);
        await Future.delayed(const Duration(milliseconds: 10));
        await dataSource.saveSearchTerm(term3);
        
        final history = await dataSource.getSearchHistory();
        expect(history, [term3, term2, term1]);
      });

      test('should limit history to 20 items', () async {
        // Add 25 search terms
        for (int i = 0; i < 25; i++) {
          await dataSource.saveSearchTerm('term$i');
          await Future.delayed(const Duration(milliseconds: 1));
        }
        
        final history = await dataSource.getSearchHistory();
        expect(history.length, 20);
        // Should contain the most recent 20 terms
        expect(history, contains('term24'));
        expect(history, contains('term5'));
        expect(history, isNot(contains('term4')));
      });

      test('should return correct number of items when less than limit', () async {
        const terms = ['eminem', 'drake', 'kendrick'];
        
        for (final term in terms) {
          await dataSource.saveSearchTerm(term);
          await Future.delayed(const Duration(milliseconds: 1));
        }
        
        final history = await dataSource.getSearchHistory();
        expect(history.length, 3);
        expect(history, ['kendrick', 'drake', 'eminem']);
      });
    });

    group('clearSearchHistory', () {
      test('should clear all search history', () async {
        const terms = ['eminem', 'drake', 'kendrick'];
        
        for (final term in terms) {
          await dataSource.saveSearchTerm(term);
        }
        
        // Verify history exists
        var history = await dataSource.getSearchHistory();
        expect(history.length, 3);
        
        // Clear history
        await dataSource.clearSearchHistory();
        
        // Verify history is cleared
        history = await dataSource.getSearchHistory();
        expect(history, isEmpty);
      });

      test('should not throw error when clearing empty history', () async {
        await dataSource.clearSearchHistory();
        
        final history = await dataSource.getSearchHistory();
        expect(history, isEmpty);
      });
    });

    group('integration tests', () {
      test('should maintain history order after multiple operations', () async {
        const terms = ['eminem', 'drake', 'kendrick', 'jcole'];
        
        // Add terms
        for (final term in terms) {
          await dataSource.saveSearchTerm(term);
          await Future.delayed(const Duration(milliseconds: 1));
        }
        
        // Verify initial order
        var history = await dataSource.getSearchHistory();
        expect(history, ['jcole', 'kendrick', 'drake', 'eminem']);
        
        // Add a duplicate term (should update timestamp)
        await Future.delayed(const Duration(milliseconds: 10));
        await dataSource.saveSearchTerm('drake');
        
        // Verify drake moved to the top
        history = await dataSource.getSearchHistory();
        expect(history, ['drake', 'jcole', 'kendrick', 'eminem']);
      });

      test('should handle rapid successive saves', () async {
        final terms = List.generate(10, (i) => 'term$i');
        
        // Save all terms rapidly
        for (final term in terms) {
          await dataSource.saveSearchTerm(term);
        }
        
        final history = await dataSource.getSearchHistory();
        expect(history.length, 10);
        expect(history, contains('term9'));
        expect(history, contains('term0'));
      });

      test('should handle mixed case and special characters', () async {
        const terms = [
          'Eminem',
          'eminem',
          'EMINEM',
          'eminem & dr. dre',
          'eminem-rap',
          'eminem_rapper',
        ];
        
        for (final term in terms) {
          await dataSource.saveSearchTerm(term);
          await Future.delayed(const Duration(milliseconds: 1));
        }
        
        final history = await dataSource.getSearchHistory();
        expect(history.length, 6);
        expect(history, contains('eminem_rapper'));
        expect(history, contains('eminem-rap'));
        expect(history, contains('eminem & dr. dre'));
      });
    });
  });
}
