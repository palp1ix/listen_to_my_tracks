import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'artist_model.g.dart';

@JsonSerializable()
class ArtistModel extends Equatable {
  const ArtistModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final int id;
  final String name;

  // The JsonKey annotation maps the 'picture_big' field from the API response
  // to our 'imageUrl' property. This keeps our model's naming conventions
  // clean and consistent with Dart standards.
  @JsonKey(name: 'picture_big')
  final String imageUrl;

  // Factory constructor for creating an instance from JSON.
  factory ArtistModel.fromJson(Map<String, dynamic> json) =>
      _$ArtistModelFromJson(json);

  // Method for converting an instance to JSON.
  Map<String, dynamic> toJson() => _$ArtistModelToJson(this);

  @override
  List<Object?> get props => [id, name, imageUrl];
}
