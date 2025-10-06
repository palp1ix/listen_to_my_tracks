import 'package:auto_route/auto_route.dart';
import 'package:listen_to_my_tracks/app/router/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: SearchResultsRoute.page),
    AutoRoute(page: TrackDetailsRoute.page),
  ];
}
