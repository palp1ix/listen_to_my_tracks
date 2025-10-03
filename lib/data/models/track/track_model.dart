import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:listen_to_my_tracks/data/models/album/album_model.dart';
import 'package:listen_to_my_tracks/data/models/artist/artist_model.dart';

part 'track_model.g.dart';

// The main DTO for a track.
@JsonSerializable(explicitToJson: true)
class TrackModel extends Equatable {
  const TrackModel({
    required this.id,
    required this.title,
    required this.link,
    required this.duration,
    required this.previewUrl,
    required this.artist,
    required this.album,
  });

  final int id;
  final String title;
  final String link;
  final int duration;

  @JsonKey(name: 'preview')
  final String previewUrl;

  final ArtistModel artist;
  final AlbumModel album;

  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    link,
    duration,
    previewUrl,
    artist,
    album,
  ];
}

// Helper model to parse the top-level search response from the API.
@JsonSerializable()
class TrackSearchResponse extends Equatable {
  const TrackSearchResponse({required this.data});

  final List<TrackModel> data;

  factory TrackSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$TrackSearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TrackSearchResponseToJson(this);

  @override
  List<Object?> get props => [data];
}
