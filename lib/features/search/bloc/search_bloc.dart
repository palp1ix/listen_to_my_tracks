import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/domain/repositories/music_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._musicRepository) : super(SearchInitial()) {
    on<SearchRequested>(_onSearchRequested);
    on<SearchCleared>(_onSearchCleared);
  }

  FutureOr<void> _onSearchCleared(event, emit) {
    emit(SearchInitial());
  }

  final MusicRepository _musicRepository;

  FutureOr<void> _onSearchRequested(event, emit) async {
    emit(SearchLoading());
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
