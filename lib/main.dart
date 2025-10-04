import 'package:flutter/material.dart';
import 'package:listen_to_my_tracks/app/resources/theme.dart';
import 'package:listen_to_my_tracks/app/router/router.dart';

void main() {
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
    return MaterialApp.router(
      // The light theme is the default.
      theme: AppTheme.lightTheme,
      // The dark theme is used when the system requests it.
      darkTheme: AppTheme.darkTheme,
      // This makes the app theme react to system settings.
      themeMode: ThemeMode.system,
      // Router configuration
      routerConfig: _router.config(),
    );
  }
}
