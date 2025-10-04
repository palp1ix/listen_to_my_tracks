import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:listen_to_my_tracks/data/datasources/music_remote_datasource.dart';
import 'package:listen_to_my_tracks/data/mappers/track_mapper.dart';
import 'package:listen_to_my_tracks/domain/entities/track.dart';
import 'package:listen_to_my_tracks/domain/repositories/music_repository.dart';

// This class implements the MusicRepository contract defined in the domain layer.
// It acts as the single source of truth for music data.
class MusicRepositoryImpl implements MusicRepository {
  final MusicRemoteDataSource _remoteDataSource;

  // It depends on an abstraction (MusicRemoteDataSource) rather than a concrete
  // implementation, following the Dependency Inversion Principle.
  MusicRepositoryImpl({required MusicRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<TrackEntity>, AppException>> searchTracks({
    required String query,
  }) async {
    try {
      // 1. Fetch data models from the remote data source.
      final trackModels = await _remoteDataSource.searchTracks(query: query);

      // 2. Map the data models to domain entities.
      final trackEntities = trackModels.map((model) => model.toEntity()).toList();

      // 3. Return a successful result, wrapping the domain entities.
      return Success(trackEntities);
    } on AppException catch (e) {
      // 4. If any AppException is thrown by the data source, catch it
      //    and return a failure result. This ensures that the upper layers
      //    (UseCases/BLoCs) only have to deal with the clean Result type.
      return Failure(e);
    }
  }
}