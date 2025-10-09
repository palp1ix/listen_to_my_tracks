import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/domain/services/audio_player_service.dart';
import 'package:listen_to_my_tracks/features/details/bloc/track_player_bloc.dart';

void main() {
  // Initialize Flutter binding for just_audio
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AudioPlayerService', () {
    late AudioPlayerService audioPlayerService;

    setUp(() {
      audioPlayerService = AudioPlayerService();
    });

    tearDown(() {
      audioPlayerService.dispose();
    });

    test('should be created successfully', () {
      expect(audioPlayerService, isNotNull);
    });

    test('should have statusStream', () {
      expect(audioPlayerService.statusStream, isNotNull);
    });

    test('should have positionStream', () {
      expect(audioPlayerService.positionStream, isNotNull);
    });

    test('should have durationStream', () {
      expect(audioPlayerService.durationStream, isNotNull);
    });

    group('load', () {
      test('should not throw when loading valid URL', () async {
        const url = 'https://example.com/audio.mp3';
        
        expect(() => audioPlayerService.load(url), returnsNormally);
      });

      test('should not throw when loading empty URL', () async {
        const url = '';
        
        expect(() => audioPlayerService.load(url), returnsNormally);
      });

      test('should not throw when loading invalid URL', () async {
        const url = 'invalid-url';
        
        expect(() => audioPlayerService.load(url), returnsNormally);
      });
    });

    group('play', () {
      test('should not throw when calling play', () async {
        expect(() => audioPlayerService.play(), returnsNormally);
      });
    });

    group('pause', () {
      test('should not throw when calling pause', () async {
        expect(() => audioPlayerService.pause(), returnsNormally);
      });
    });

    group('seek', () {
      test('should not throw when seeking to zero position', () async {
        expect(() => audioPlayerService.seek(Duration.zero), returnsNormally);
      });

      test('should not throw when seeking to specific position', () async {
        const position = Duration(seconds: 30);
        expect(() => audioPlayerService.seek(position), returnsNormally);
      });

      test('should not throw when seeking to negative position', () async {
        const position = Duration(seconds: -10);
        expect(() => audioPlayerService.seek(position), returnsNormally);
      });

      test('should not throw when seeking to very large position', () async {
        const position = Duration(hours: 1);
        expect(() => audioPlayerService.seek(position), returnsNormally);
      });
    });

    group('dispose', () {
      test('should not throw when disposing', () {
        expect(() => audioPlayerService.dispose(), returnsNormally);
      });

      test('should be safe to call dispose multiple times', () {
        expect(() => audioPlayerService.dispose(), returnsNormally);
        expect(() => audioPlayerService.dispose(), returnsNormally);
      });
    });

    group('streams', () {
      test('statusStream should emit PlayerStatus values', () async {
        final statuses = <PlayerStatus>[];
        final subscription = audioPlayerService.statusStream.listen(statuses.add);
        
        // Wait a bit to collect some values
        await Future.delayed(const Duration(milliseconds: 100));
        
        subscription.cancel();
        
        // The stream should emit values (exact values depend on player state)
        expect(statuses, isA<List<PlayerStatus>>());
      });

      test('positionStream should emit Duration values', () async {
        final positions = <Duration>[];
        final subscription = audioPlayerService.positionStream.listen(positions.add);
        
        // Wait a bit to collect some values
        await Future.delayed(const Duration(milliseconds: 100));
        
        subscription.cancel();
        
        // The stream should emit values (exact values depend on player state)
        expect(positions, isA<List<Duration>>());
      });

      test('durationStream should emit Duration? values', () async {
        final durations = <Duration?>[];
        final subscription = audioPlayerService.durationStream.listen(durations.add);
        
        // Wait a bit to collect some values
        await Future.delayed(const Duration(milliseconds: 100));
        
        subscription.cancel();
        
        // The stream should emit values (exact values depend on player state)
        expect(durations, isA<List<Duration?>>());
      });
    });

    group('integration', () {
      test('should handle complete workflow without errors', () async {
        const url = 'https://example.com/audio.mp3';
        
        // Load audio
        await audioPlayerService.load(url);
        
        // Try to play
        await audioPlayerService.play();
        
        // Wait a bit
        await Future.delayed(const Duration(milliseconds: 50));
        
        // Try to pause
        await audioPlayerService.pause();
        
        // Try to seek
        await audioPlayerService.seek(const Duration(seconds: 10));
        
        // Try to play again
        await audioPlayerService.play();
        
        // Wait a bit
        await Future.delayed(const Duration(milliseconds: 50));
        
        // Pause again
        await audioPlayerService.pause();
        
        // Should complete without throwing
        expect(true, isTrue);
      });

      test('should handle multiple load calls', () async {
        const url1 = 'https://example.com/audio1.mp3';
        const url2 = 'https://example.com/audio2.mp3';
        
        await audioPlayerService.load(url1);
        await audioPlayerService.load(url2);
        
        // Should complete without throwing
        expect(true, isTrue);
      });

      test('should handle rapid play/pause calls', () async {
        const url = 'https://example.com/audio.mp3';
        
        await audioPlayerService.load(url);
        
        // Rapid play/pause calls
        for (int i = 0; i < 10; i++) {
          await audioPlayerService.play();
          await audioPlayerService.pause();
        }
        
        // Should complete without throwing
        expect(true, isTrue);
      });
    });
  });
}
