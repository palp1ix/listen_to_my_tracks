part of 'track_player_bloc.dart';

// An enum to represent the various statuses of the audio player.
// Using an enum makes the state explicit and reduces the chance of errors.
enum PlayerStatus {
  initial,    // Before anything has been loaded.
  loading,    // The track is being loaded from the network.
  playing,    // The track is currently playing.
  paused,     // The track is paused.
  completed,  // The track has finished playing.
  error,      // An error occurred.
}

class TrackPlayerState extends Equatable {
  const TrackPlayerState({
    this.status = PlayerStatus.initial,
    this.totalDuration = Duration.zero,
    this.currentPosition = Duration.zero,
    this.errorMessage,
  });

  final PlayerStatus status;
  final Duration totalDuration;
  final Duration currentPosition;
  final String? errorMessage;
  
  // A convenience method to create a new state instance based on the current one.
  // This is a core principle of immutable state management.
  TrackPlayerState copyWith({
    PlayerStatus? status,
    Duration? totalDuration,
    Duration? currentPosition,
    String? errorMessage,
  }) {
    return TrackPlayerState(
      status: status ?? this.status,
      totalDuration: totalDuration ?? this.totalDuration,
      currentPosition: currentPosition ?? this.currentPosition,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    totalDuration,
    currentPosition,
    errorMessage,
  ];
}