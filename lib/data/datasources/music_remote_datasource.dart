import 'package:dio/dio.dart';
import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/data/models/track/track_model.dart';

// Abstract contract for the remote data source.
// This defines what data can be fetched from the API.
abstract interface class MusicRemoteDataSource {
  Future<List<TrackModel>> searchTracks({required String query});
  Future<List<TrackModel>> getChart();
}

// Concrete implementation of the data source using the Dio package.
class MusicRemoteDataSourceImpl implements MusicRemoteDataSource {
  final Dio _dio;

  // The Dio instance is injected, allowing for easy configuration and testing.
  MusicRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<TrackModel>> searchTracks({required String query}) async {
    try {
      final response = await _dio.get('/search', queryParameters: {'q': query});

      if (response.statusCode == 200) {
        // The API wraps the list of tracks in a 'data' object.
        // The TrackSearchResponse model is used to parse this structure.
        final searchResult = TrackSearchResponse.fromJson(response.data);
        return searchResult.data;
      } else {
        // Handle non-200 responses as server exceptions.
        throw ServerException(
          message: 'Failed to load tracks: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      // DioException is caught to provide more specific error types.
      // This helps in distinguishing between network issues and server errors.
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException();
      }
      throw ServerException(message: e.message ?? 'An unknown error occurred');
    }
  }

    @override
  Future<List<TrackModel>> getChart() async {
    try {
      final response = await _dio.get('/chart');

      if (response.statusCode == 200) {
        // The API wraps the list of tracks in a 'data' object.
        // The TrackSearchResponse model is used to parse this structure.
        final searchResult = TrackSearchResponse.fromJson(response.data['tracks']);
        return searchResult.data;
      } else {
        // Handle non-200 responses as server exceptions.
        throw ServerException(
          message: 'Failed to load tracks: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      // DioException is caught to provide more specific error types.
      // This helps in distinguishing between network issues and server errors.
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException();
      }
      throw ServerException(message: e.message ?? 'An unknown error occurred');
    }
  }
}