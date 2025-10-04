// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;
import 'package:listen_to_my_tracks/features/home/view/home_screen.dart' as _i1;
import 'package:listen_to_my_tracks/features/search/view/search_results_screen.dart'
    as _i2;

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i3.PageRouteInfo<void> {
  const HomeRoute({List<_i3.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomeScreen();
    },
  );
}

/// generated route for
/// [_i2.SearchResultsScreen]
class SearchResultsRoute extends _i3.PageRouteInfo<SearchResultsRouteArgs> {
  SearchResultsRoute({
    _i4.Key? key,
    required String query,
    List<_i3.PageRouteInfo>? children,
  }) : super(
         SearchResultsRoute.name,
         args: SearchResultsRouteArgs(key: key, query: query),
         initialChildren: children,
       );

  static const String name = 'SearchResultsRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SearchResultsRouteArgs>();
      return _i2.SearchResultsScreen(key: args.key, query: args.query);
    },
  );
}

class SearchResultsRouteArgs {
  const SearchResultsRouteArgs({this.key, required this.query});

  final _i4.Key? key;

  final String query;

  @override
  String toString() {
    return 'SearchResultsRouteArgs{key: $key, query: $query}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchResultsRouteArgs) return false;
    return key == other.key && query == other.query;
  }

  @override
  int get hashCode => key.hashCode ^ query.hashCode;
}
