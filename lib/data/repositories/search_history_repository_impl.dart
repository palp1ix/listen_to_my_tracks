import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/data/datasources/search_history_local_datasource.dart';
import 'package:listen_to_my_tracks/domain/repositories/search_history_repository.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  SearchHistoryRepositoryImpl({
    required SearchHistoryLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final SearchHistoryLocalDataSource _localDataSource;

  @override
  Future<Result<List<String>, AppException>> getSearchHistory() async {
    try {
      final history = await _localDataSource.getSearchHistory();
      return Success(history);
    } catch (e) {
      return Failure(AppException(message: e.toString()));
    }
  }

  @override
  Future<Result<void, AppException>> saveSearchTerm({
    required String term,
  }) async {
    try {
      await _localDataSource.saveSearchTerm(term);
      return Success(null);
    } catch (e) {
      return Failure(AppException(message: e.toString()));
    }
  }
}
