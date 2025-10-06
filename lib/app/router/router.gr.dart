// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:listen_to_my_tracks/domain/entities/track.dart' as _i6;
import 'package:listen_to_my_tracks/features/details/view/track_details_screen.dart'
    as _i3;
import 'package:listen_to_my_tracks/features/home/view/home_screen.dart' as _i1;
import 'package:listen_to_my_tracks/features/search/view/search_results_screen.dart'
    as _i2;

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomeScreen();
    },
  );
}

/// generated route for
/// [_i2.SearchResultsScreen]
class SearchResultsRoute extends _i4.PageRouteInfo<void> {
  const SearchResultsRoute({List<_i4.PageRouteInfo>? children})
    : super(SearchResultsRoute.name, initialChildren: children);

  static const String name = 'SearchResultsRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.SearchResultsScreen();
    },
  );
}

/// generated route for
/// [_i3.TrackDetailsScreen]
class TrackDetailsRoute extends _i4.PageRouteInfo<TrackDetailsRouteArgs> {
  TrackDetailsRoute({
    _i5.Key? key,
    required _i6.TrackEntity track,
    List<_i4.PageRouteInfo>? children,
  }) : super(
         TrackDetailsRoute.name,
         args: TrackDetailsRouteArgs(key: key, track: track),
         initialChildren: children,
       );

  static const String name = 'TrackDetailsRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TrackDetailsRouteArgs>();
      return _i3.TrackDetailsScreen(key: args.key, track: args.track);
    },
  );
}

class TrackDetailsRouteArgs {
  const TrackDetailsRouteArgs({this.key, required this.track});

  final _i5.Key? key;

  final _i6.TrackEntity track;

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
