import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/core/widgets/track_list_tile.dart';

void main() {
  group('TrackListTile', () {
    testWidgets('should display track information correctly', (WidgetTester tester) async {
      const imageUrl = 'https://example.com/album.jpg';
      const trackTitle = 'Without Me';
      const artist = 'Eminem';
      bool onTapCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrackListTile(
              imageUrl: imageUrl,
              trackTitle: trackTitle,
              artist: artist,
              onTap: () {
                onTapCalled = true;
              },
            ),
          ),
        ),
      );

      expect(find.text(trackTitle), findsOneWidget);
      expect(find.text(artist), findsOneWidget);
      expect(find.byType(FadeInImage), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (WidgetTester tester) async {
      bool onTapCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrackListTile(
              imageUrl: 'https://example.com/album.jpg',
              trackTitle: 'Without Me',
              artist: 'Eminem',
              onTap: () {
                onTapCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(onTapCalled, isTrue);
    });

    testWidgets('should handle empty strings', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrackListTile(
              imageUrl: '',
              trackTitle: '',
              artist: '',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text(''), findsNWidgets(2)); // trackTitle and artist
      expect(find.byType(FadeInImage), findsOneWidget);
    });

    testWidgets('should handle long text', (WidgetTester tester) async {
      const longTitle = 'This is a very long track title that should be handled properly by the widget';
      const longArtist = 'This is a very long artist name that should be handled properly by the widget';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrackListTile(
              imageUrl: 'https://example.com/album.jpg',
              trackTitle: longTitle,
              artist: longArtist,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text(longTitle), findsOneWidget);
      expect(find.text(longArtist), findsOneWidget);
    });

    testWidgets('should handle special characters in text', (WidgetTester tester) async {
      const specialTitle = 'Track & Title (Special)';
      const specialArtist = 'Artist & Name (Special)';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrackListTile(
              imageUrl: 'https://example.com/album.jpg',
              trackTitle: specialTitle,
              artist: specialArtist,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text(specialTitle), findsOneWidget);
      expect(find.text(specialArtist), findsOneWidget);
    });

    testWidgets('should have correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrackListTile(
              imageUrl: 'https://example.com/album.jpg',
              trackTitle: 'Without Me',
              artist: 'Eminem',
              onTap: () {},
            ),
          ),
        ),
      );

      final titleText = tester.widget<Text>(find.text('Without Me'));
      expect(titleText.style?.fontWeight, FontWeight.bold);

      final artistText = tester.widget<Text>(find.text('Eminem'));
      expect(artistText.style?.fontWeight, isNull);
    });

    testWidgets('should have correct image dimensions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrackListTile(
              imageUrl: 'https://example.com/album.jpg',
              trackTitle: 'Without Me',
              artist: 'Eminem',
              onTap: () {},
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pump();

      final fadeInImage = tester.widget<FadeInImage>(find.byType(FadeInImage));
      expect(fadeInImage.width, 56);
      expect(fadeInImage.height, 56);
      expect(fadeInImage.fit, BoxFit.cover);
    });

    testWidgets('should have correct border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrackListTile(
              imageUrl: 'https://example.com/album.jpg',
              trackTitle: 'Without Me',
              artist: 'Eminem',
              onTap: () {},
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pump();

      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('should use correct placeholder image', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrackListTile(
              imageUrl: 'https://example.com/album.jpg',
              trackTitle: 'Without Me',
              artist: 'Eminem',
              onTap: () {},
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pump();

      final fadeInImage = tester.widget<FadeInImage>(find.byType(FadeInImage));
      expect(fadeInImage.placeholder, isA<AssetImage>());
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TrackListTile(
              imageUrl: 'https://example.com/album.jpg',
              trackTitle: 'Without Me',
              artist: 'Eminem',
              onTap: () {},
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pump();

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(FadeInImage), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(2));
    });
  });
}
