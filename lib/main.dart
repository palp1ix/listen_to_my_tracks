import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listen_to_my_tracks/app/di/service_locator.dart';
import 'package:listen_to_my_tracks/app/resources/theme.dart';
import 'package:listen_to_my_tracks/app/router/router.dart';
import 'package:listen_to_my_tracks/features/artist_tracks/bloc/artist_tracks_bloc.dart';
import 'package:listen_to_my_tracks/features/details/bloc/track_player_bloc.dart';
import 'package:listen_to_my_tracks/features/home/bloc/home_bloc.dart';
import 'package:listen_to_my_tracks/features/search/bloc/search_bloc.dart';

void main() async {
  // This is required to ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize all dependencies before running the app.
  await configureDependencies();
  // Start the app.
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeBloc>()),
        BlocProvider(create: (_) => sl<SearchBloc>()),
        BlocProvider(create: (_) => sl<TrackPlayerBloc>()),
        BlocProvider(create: (_) => sl<ArtistTracksBloc>()),
      ],
      child: MaterialApp.router(
        // The light theme is the default.
        theme: AppTheme.lightTheme,
        // The dark theme is used when the system requests it.
        darkTheme: AppTheme.darkTheme,
        // This makes the app theme react to system settings.
        themeMode: ThemeMode.system,
        // Router configuration
        routerConfig: _router.config(),
      ),
    );
  }
}
