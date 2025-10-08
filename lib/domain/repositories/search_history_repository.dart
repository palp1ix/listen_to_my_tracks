// Defines the contract for music-related data operations.
import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';

abstract interface class SearchHistoryRepository {
  // Saves a search term to the local history.
  Future<Result<void, AppException>> saveSearchTerm({
    required String term,
  });

  // Returns a list of chart-topping tracks.
  Future<Result<List<String>, AppException>> getSearchHistory();
}