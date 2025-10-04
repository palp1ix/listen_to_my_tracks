import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/domain/repositories/music_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MusicRepository _musicRepository;

  HomeBloc(this._musicRepository) : super(HomeInitial()) {
    on<HomeScreenStarted>(_onHomeScreenStarted);
  }

  FutureOr<void> _onHomeScreenStarted(event, emit) async {
    emit(HomeDataLoading());
    final result = await _musicRepository.getChart();
  
    switch (result) {
      case Success(value: final chart):
        emit(HomeDataLoaded(chart));
      
      case Failure(exception: final exception):
        emit(HomeDataError(exception.message)); 
    }
  }
}
