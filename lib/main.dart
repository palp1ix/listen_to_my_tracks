import 'package:flutter/material.dart';
import 'package:listen_to_my_tracks/app/resources/theme.dart';
import 'package:listen_to_my_tracks/features/home/view/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The light theme is the default.
      theme: AppTheme.lightTheme,
      // The dark theme is used when the system requests it.
      darkTheme: AppTheme.darkTheme,
      // This makes the app theme react to system settings.
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}
