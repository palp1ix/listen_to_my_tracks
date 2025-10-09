part of 'artist_tracks_bloc.dart';

sealed class ArtistTracksState extends Equatable {
  const ArtistTracksState();

  @override
  List<Object> get props => [];
}

final class ArtistTracksInitial extends ArtistTracksState {}

final class ArtistTracksLoading extends ArtistTracksState {}

final class ArtistTracksLoaded extends ArtistTracksState {
  const ArtistTracksLoaded(this.tracks, this.artistId);

  final List<TrackEntity> tracks;
  // To retry loading tracks for the same artist.
  final int artistId;

  @override
  List<Object> get props => [tracks];
}

final class ArtistTracksError extends ArtistTracksState {
  const ArtistTracksError(this.message, this.artistId);

  final String message;
  // To retry loading tracks for the same artist.
  final int artistId;

  @override
  List<Object> get props => [message];
}
