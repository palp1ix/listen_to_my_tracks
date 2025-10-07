import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:listen_to_my_tracks/features/details/bloc/track_player_bloc.dart';

// A dedicated service to encapsulate all audio player logic.
// This decouples the BLoC from the specific implementation details of `just_audio`.
class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Streams to report player state changes back to the BLoC.
  Stream<PlayerStatus> get statusStream => _audioPlayer.playerStateStream.map((state) {
        if (state.processingState == ProcessingState.completed) {
          return PlayerStatus.completed;
        }
        return state.playing ? PlayerStatus.playing : PlayerStatus.paused;
      });

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  Future<void> load(String url) async {
    try {
      await _audioPlayer.setUrl(url);
    } catch (e) {
      // Handle exceptions, e.g., network errors.
      debugPrint('Error loading audio source: $e');
      // In a real app, you'd want to propagate this error.
    }
  }

  Future<void> play() => _audioPlayer.play();

  Future<void> pause() => _audioPlayer.pause();

  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  // It's crucial to release the player's resources when it's no longer needed.
  void dispose() {
    _audioPlayer.dispose();
  }
}