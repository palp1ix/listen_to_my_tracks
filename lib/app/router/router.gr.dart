// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:listen_to_my_tracks/domain/entities/artist.dart' as _i7;
import 'package:listen_to_my_tracks/domain/entities/track.dart' as _i8;
import 'package:listen_to_my_tracks/features/artist_tracks/view/artist_tracks_screen.dart'
    as _i1;
import 'package:listen_to_my_tracks/features/details/view/track_details_screen.dart'
    as _i4;
import 'package:listen_to_my_tracks/features/home/view/home_screen.dart' as _i2;
import 'package:listen_to_my_tracks/features/search/view/search_results_screen.dart'
    as _i3;

/// generated route for
/// [_i1.ArtistTracksScreen]
class ArtistTracksRoute extends _i5.PageRouteInfo<ArtistTracksRouteArgs> {
  ArtistTracksRoute({
    _i6.Key? key,
    required _i7.ArtistEntity artist,
    List<_i5.PageRouteInfo>? children,
  }) : super(
         ArtistTracksRoute.name,
         args: ArtistTracksRouteArgs(key: key, artist: artist),
         initialChildren: children,
       );

  static const String name = 'ArtistTracksRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ArtistTracksRouteArgs>();
      return _i1.ArtistTracksScreen(key: args.key, artist: args.artist);
    },
  );
}

class ArtistTracksRouteArgs {
  const ArtistTracksRouteArgs({this.key, required this.artist});

  final _i6.Key? key;

  final _i7.ArtistEntity artist;

  @override
  String toString() {
    return 'ArtistTracksRouteArgs{key: $key, artist: $artist}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ArtistTracksRouteArgs) return false;
    return key == other.key && artist == other.artist;
  }

  @override
  int get hashCode => key.hashCode ^ artist.hashCode;
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeScreen();
    },
  );
}

/// generated route for
/// [_i3.SearchResultsScreen]
class SearchResultsRoute extends _i5.PageRouteInfo<void> {
  const SearchResultsRoute({List<_i5.PageRouteInfo>? children})
    : super(SearchResultsRoute.name, initialChildren: children);

  static const String name = 'SearchResultsRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.SearchResultsScreen();
    },
  );
}

/// generated route for
/// [_i4.TrackDetailsScreen]
class TrackDetailsRoute extends _i5.PageRouteInfo<TrackDetailsRouteArgs> {
  TrackDetailsRoute({
    _i6.Key? key,
    required _i8.TrackEntity track,
    List<_i5.PageRouteInfo>? children,
  }) : super(
         TrackDetailsRoute.name,
         args: TrackDetailsRouteArgs(key: key, track: track),
         initialChildren: children,
       );

  static const String name = 'TrackDetailsRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TrackDetailsRouteArgs>();
      return _i4.TrackDetailsScreen(key: args.key, track: args.track);
    },
  );
}

class TrackDetailsRouteArgs {
  const TrackDetailsRouteArgs({this.key, required this.track});

  final _i6.Key? key;

  final _i8.TrackEntity track;

  @override
  String toString() {
    return 'TrackDetailsRouteArgs{key: $key, track: $track}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TrackDetailsRouteArgs) return false;
    return key == other.key && track == other.track;
  }

  @override
  int get hashCode => key.hashCode ^ track.hashCode;
}
