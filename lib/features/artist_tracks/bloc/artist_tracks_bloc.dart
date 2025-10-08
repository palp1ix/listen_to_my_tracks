import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/domain/repositories/music_repository.dart';

part 'artist_tracks_event.dart';
part 'artist_tracks_state.dart';

class ArtistTracksBloc extends Bloc<ArtistTracksEvent, ArtistTracksState> {
  final MusicRepository _musicRepository;

  ArtistTracksBloc(this._musicRepository) : super(ArtistTracksInitial()) {
    on<LoadArtistTracks>(_onLoadArtistTracks);
  }

  FutureOr<void> _onLoadArtistTracks(event, emit) async {
    emit(ArtistTracksLoading());
    final result = await _musicRepository.getArtistTracks(event.artistId);
  
    switch (result) {
      case Success(value: final tracks):
        emit(ArtistTracksLoaded(tracks));
      case Failure(exception: final exception):
        emit(ArtistTracksError(exception.message));
    }
  }
}
