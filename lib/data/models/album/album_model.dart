import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'album_model.g.dart';

// DTO for an album.
@JsonSerializable()
class AlbumModel extends Equatable {
  const AlbumModel({
    required this.id,
    required this.title,
    required this.coverUrl,
  });

  final int id;
  final String title;

  // Mapping the 'cover_big' API field to our 'coverUrl' property.
  @JsonKey(name: 'cover_big')
  final String coverUrl;

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumModelToJson(this);

  @override
  List<Object?> get props => [id, title, coverUrl];
}
