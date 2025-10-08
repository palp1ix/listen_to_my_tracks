part of 'artist_tracks_bloc.dart';

sealed class ArtistTracksEvent extends Equatable {
  const ArtistTracksEvent();

  @override
  List<Object> get props => [];
}

class LoadArtistTracks extends ArtistTracksEvent {
  const LoadArtistTracks(this.artistId);

  final int artistId;

  @override
  List<Object> get props => [artistId];
}
