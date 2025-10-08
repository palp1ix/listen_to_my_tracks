part of 'artist_tracks_bloc.dart';

sealed class ArtistTracksState extends Equatable {
  const ArtistTracksState();
  
  @override
  List<Object> get props => [];
}

final class ArtistTracksInitial extends ArtistTracksState {}

final class ArtistTracksLoading extends ArtistTracksState {}

final class ArtistTracksLoaded extends ArtistTracksState {
  const ArtistTracksLoaded(this.tracks);

  final List<TrackEntity> tracks;

  @override
  List<Object> get props => [tracks];
}

final class ArtistTracksError extends ArtistTracksState {
  const ArtistTracksError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}