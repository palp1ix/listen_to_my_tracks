// lib/features/track_details/presentation/bloc/track_player_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/domain/services/audio_player_service.dart';

part 'track_player_event.dart';
part 'track_player_state.dart';

class TrackPlayerBloc extends Bloc<TrackPlayerEvent, TrackPlayerState> {
  TrackPlayerBloc({required AudioPlayerService audioPlayerService})
    : _audioPlayerService = audioPlayerService,
      super(const TrackPlayerState()) {
    // Register event handlers for events dispatched by the UI.
    on<LoadTrack>(_onLoadTrack);
    on<PlayRequested>(_onPlayRequested);
    on<PauseRequested>(_onPauseRequested);
    on<SeekRequested>(_onSeekRequested);

    // Register event handlers for internal events triggered by player streams.
    on<_PlayerStatusChanged>(_onPlayerStatusChanged);
    on<_PlayerPositionChanged>(_onPlayerPositionChanged);
    on<_PlayerDurationChanged>(_onPlayerDurationChanged);

    // Subscribe to the streams from the audio service.
    _listenToPlayerStreams();
  }

  final AudioPlayerService _audioPlayerService;

  // Stream subscriptions need to be managed to avoid memory leaks.
  StreamSubscription<PlayerStatus>? _statusSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;

  void _listenToPlayerStreams() {
    _statusSubscription = _audioPlayerService.statusStream.listen(
      (status) => add(_PlayerStatusChanged(status)),
    );
    _positionSubscription = _audioPlayerService.positionStream.listen(
      (position) => add(_PlayerPositionChanged(position)),
    );
    _durationSubscription = _audioPlayerService.durationStream.listen((
      duration,
    ) {
      if (duration != null) {
        add(_PlayerDurationChanged(duration));
      }
    });
  }

  @override
  Future<void> close() {
    // Cancel all subscriptions and dispose the player service.
    // This is a critical step to prevent memory leaks.
    _statusSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _audioPlayerService.dispose();
    return super.close();
  }

  // --- Event Handlers ---

  Future<void> _onLoadTrack(
    LoadTrack event,
    Emitter<TrackPlayerState> emit,
  ) async {
    emit(state.copyWith(status: PlayerStatus.loading));
    try {
      await _audioPlayerService.load(event.track.previewUrl);
      // After loading, we don't know if it will autoplay, so we wait for the
      // status stream to emit the actual status (usually 'paused').
    } catch (e) {
      emit(
        state.copyWith(status: PlayerStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onPlayRequested(
    PlayRequested event,
    Emitter<TrackPlayerState> emit,
  ) async {
    await _audioPlayerService.play();
  }

  Future<void> _onPauseRequested(
    PauseRequested event,
    Emitter<TrackPlayerState> emit,
  ) async {
    await _audioPlayerService.pause();
  }

  Future<void> _onSeekRequested(
    SeekRequested event,
    Emitter<TrackPlayerState> emit,
  ) async {
    await _audioPlayerService.seek(event.position);
  }

  void _onPlayerStatusChanged(
    _PlayerStatusChanged event,
    Emitter<TrackPlayerState> emit,
  ) {
    emit(state.copyWith(status: event.status));
  }

  void _onPlayerPositionChanged(
    _PlayerPositionChanged event,
    Emitter<TrackPlayerState> emit,
  ) {
    emit(state.copyWith(currentPosition: event.position));
  }

  void _onPlayerDurationChanged(
    _PlayerDurationChanged event,
    Emitter<TrackPlayerState> emit,
  ) {
    emit(state.copyWith(totalDuration: event.duration));
  }
}
