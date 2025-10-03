// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) => AlbumModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  coverUrl: json['cover_big'] as String,
);

Map<String, dynamic> _$AlbumModelToJson(AlbumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'cover_big': instance.coverUrl,
    };
