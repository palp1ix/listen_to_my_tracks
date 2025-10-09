part of 'track_player_bloc.dart';

// The base class for all events related to the track player.
abstract class TrackPlayerEvent extends Equatable {
  const TrackPlayerEvent();

  @override
  List<Object> get props => [];
}

// Event to load a track and prepare it for playback.
class LoadTrack extends TrackPlayerEvent {
  const LoadTrack({required this.track});
  final TrackEntity track;

  @override
  List<Object> get props => [track];
}

// Event triggered when the user taps the play button.
class PlayRequested extends TrackPlayerEvent {}

// Event triggered when the user taps the pause button.
class PauseRequested extends TrackPlayerEvent {}

// Event triggered when the user drags the slider to a new position.
class SeekRequested extends TrackPlayerEvent {
  const SeekRequested(this.position);
  final Duration position;

  @override
  List<Object> get props => [position];
}

// Private events used by the BLoC to update its state based on feedback
// from the audio player service. The UI will not dispatch these directly.

class _PlayerStatusChanged extends TrackPlayerEvent {
  const _PlayerStatusChanged(this.status);
  final PlayerStatus status;
}

class _PlayerPositionChanged extends TrackPlayerEvent {
  const _PlayerPositionChanged(this.position);
  final Duration position;
}

class _PlayerDurationChanged extends TrackPlayerEvent {
  const _PlayerDurationChanged(this.duration);
  final Duration duration;
}