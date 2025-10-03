// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackModel _$TrackModelFromJson(Map<String, dynamic> json) => TrackModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  link: json['link'] as String,
  duration: (json['duration'] as num).toInt(),
  previewUrl: json['preview'] as String,
  artist: ArtistModel.fromJson(json['artist'] as Map<String, dynamic>),
  album: AlbumModel.fromJson(json['album'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TrackModelToJson(TrackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'link': instance.link,
      'duration': instance.duration,
      'preview': instance.previewUrl,
      'artist': instance.artist.toJson(),
      'album': instance.album.toJson(),
    };

TrackSearchResponse _$TrackSearchResponseFromJson(Map<String, dynamic> json) =>
    TrackSearchResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => TrackModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrackSearchResponseToJson(
  TrackSearchResponse instance,
) => <String, dynamic>{'data': instance.data};
