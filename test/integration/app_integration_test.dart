import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/app/di/service_locator.dart';
import 'package:listen_to_my_tracks/domain/repositories/music_repository.dart';
import 'package:listen_to_my_tracks/app/router/router.dart';
import 'package:listen_to_my_tracks/features/artist_tracks/bloc/artist_tracks_bloc.dart';
import 'package:listen_to_my_tracks/features/details/bloc/track_player_bloc.dart';
import 'package:listen_to_my_tracks/features/home/bloc/home_bloc.dart';
import 'package:listen_to_my_tracks/features/search/bloc/search_bloc.dart';
import 'package:listen_to_my_tracks/main.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('should initialize app with all BLoCs', (WidgetTester tester) async {
      // Initialize dependencies
      await configureDependencies();
      
      // Build the app
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      // Verify that the app builds without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should have all required BLoCs in service locator', (WidgetTester tester) async {
      // Initialize dependencies
      await configureDependencies();
      
      // Verify that all BLoCs are registered
      expect(sl<HomeBloc>(), isA<HomeBloc>());
      expect(sl<SearchBloc>(), isA<SearchBloc>());
      expect(sl<TrackPlayerBloc>(), isA<TrackPlayerBloc>());
      expect(sl<ArtistTracksBloc>(), isA<ArtistTracksBloc>());
    });

    testWidgets('should have router configured', (WidgetTester tester) async {
      // Initialize dependencies
      await configureDependencies();
      
      // Build the app
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      // Verify that the router is configured
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.routerConfig, isNotNull);
    });

    testWidgets('should have theme configured', (WidgetTester tester) async {
      // Initialize dependencies
      await configureDependencies();
      
      // Build the app
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      // Verify that themes are configured
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
      expect(materialApp.themeMode, ThemeMode.system);
    });

    testWidgets('should not show debug banner', (WidgetTester tester) async {
      // Initialize dependencies
      await configureDependencies();
      
      // Build the app
      await tester.pumpWidget(const MainApp());
      await tester.pumpAndSettle();

      // Verify that debug banner is disabled
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
    });
  });

  group('Service Locator Integration', () {
    setUp(() async {
      // Reset service locator before each test
      await sl.reset();
    });

    test('should register all dependencies without errors', () async {
      // This test verifies that all dependencies can be registered without throwing exceptions
      expect(() => configureDependencies(), returnsNormally);
    });

    test('should be able to reset and reconfigure dependencies', () async {
      // Configure dependencies
      await configureDependencies();
      
      // Verify they are registered
      expect(sl<HomeBloc>(), isA<HomeBloc>());
      
      // Reset
      await sl.reset();
      
      // Reconfigure
      await configureDependencies();
      
      // Verify they are registered again
      expect(sl<HomeBloc>(), isA<HomeBloc>());
    });
  });

  group('Router Integration', () {
    test('should have all routes configured', () {
      final router = AppRouter();
      final config = router.config();
      
      // Verify that the router config is not null
      expect(config, isNotNull);
    });
  });
}
