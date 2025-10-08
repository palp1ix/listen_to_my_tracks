import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/domain/repositories/music_repository.dart';
import 'package:listen_to_my_tracks/domain/repositories/search_history_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MusicRepository _musicRepository;
  final SearchHistoryRepository _searchHistoryRepository;

  SearchBloc(this._musicRepository, this._searchHistoryRepository)
    : super(SearchInitial()) {
    on<SearchRequested>(_onSearchRequested);
    on<SearchCleared>(_onHistoryRequested);
    on<HistoryRequested>(_onHistoryRequested);
  }

  // Function to save the search term to history.
  FutureOr<void> _saveSearchTerm(String term) async {
    await _searchHistoryRepository.saveSearchTerm(term: term);
  }

  FutureOr<void> _onHistoryRequested(event, emit) async {
    final history = await _searchHistoryRepository.getSearchHistory();

    switch (history) {
      case Success(value: final terms):
        emit(SearchInitial(history: terms));

      // If we have a failure, we can still emit an initial state
      case Failure():
        emit(SearchInitial(history: []));
    }
  }

  FutureOr<void> _onSearchRequested(event, emit) async {
    emit(SearchLoading());
    // Save the search term to history asynchronously.
    await _saveSearchTerm(event.query);
    // Perform the search using the repository.
    final result = await _musicRepository.searchTracks(query: event.query);
    switch (result) {
      case Success(value: final tracks):
        // An empty list is a valid success case, but the UI might need
        // to show a specific "Not Found" message. The UI can decide this
        // based on whether the list is empty.
        emit(SearchSuccess(tracks));

      // Pattern matching also extracts the exception for us.
      case Failure(exception: final exception):
        emit(SearchFailure(exception.message));
    }
  }
}
