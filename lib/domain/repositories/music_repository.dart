import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';

// Defines the contract for music-related data operations.
abstract interface class MusicRepository {
  // Searches for tracks based on a user-provided query.
  //
  // Returns a [Result] type, which encapsulates either a list of [TrackEntity]
  // on success or an [AppException] on failure.
  Future<Result<List<TrackEntity>, AppException>> searchTracks({
    required String query,
  });

  // Returns a list of chart-topping tracks.
  Future<Result<List<TrackEntity>, AppException>> getChart();

  // Returns a list of tracks by a specific artist.
  Future<Result<List<TrackEntity>, AppException>> getArtistTracks(int artistId);
}