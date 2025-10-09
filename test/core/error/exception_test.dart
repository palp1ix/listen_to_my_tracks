import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:equatable/equatable.dart';

void main() {
  group('AppException', () {
    test('should be a subclass of Equatable', () {
      const exception = AppException(message: 'Test error');
      expect(exception, isA<Equatable>());
    });

    test('should implement Exception', () {
      const exception = AppException(message: 'Test error');
      expect(exception, isA<Exception>());
    });

    test('should have correct message', () {
      const exception = AppException(message: 'Test error');
      expect(exception.message, 'Test error');
    });

    test('should support equality', () {
      const exception1 = AppException(message: 'Test error');
      const exception2 = AppException(message: 'Test error');
      
      expect(exception1, equals(exception2));
    });

    test('should support inequality', () {
      const exception1 = AppException(message: 'Test error');
      const exception2 = AppException(message: 'Different error');
      
      expect(exception1, isNot(equals(exception2)));
    });

    test('should handle empty message', () {
      const exception = AppException(message: '');
      expect(exception.message, '');
    });

    test('should handle long message', () {
      const longMessage = 'This is a very long error message that contains multiple sentences and should be handled properly by the exception class.';
      const exception = AppException(message: longMessage);
      expect(exception.message, longMessage);
    });
  });

  group('ServerException', () {
    test('should be a subclass of AppException', () {
      const exception = ServerException(message: 'Server error');
      expect(exception, isA<AppException>());
    });

    test('should be a subclass of Equatable', () {
      const exception = ServerException(message: 'Server error');
      expect(exception, isA<Equatable>());
    });

    test('should implement Exception', () {
      const exception = ServerException(message: 'Server error');
      expect(exception, isA<Exception>());
    });

    test('should have correct message', () {
      const exception = ServerException(message: 'Server error');
      expect(exception.message, 'Server error');
    });

    test('should support equality', () {
      const exception1 = ServerException(message: 'Server error');
      const exception2 = ServerException(message: 'Server error');
      
      expect(exception1, equals(exception2));
    });

    test('should support inequality', () {
      const exception1 = ServerException(message: 'Server error');
      const exception2 = ServerException(message: 'Different server error');
      
      expect(exception1, isNot(equals(exception2)));
    });

    test('should handle different status codes in message', () {
      const exception404 = ServerException(message: '404 Not Found');
      const exception500 = ServerException(message: '500 Internal Server Error');
      
      expect(exception404.message, '404 Not Found');
      expect(exception500.message, '500 Internal Server Error');
      expect(exception404, isNot(equals(exception500)));
    });

    test('should handle empty message', () {
      const exception = ServerException(message: '');
      expect(exception.message, '');
    });
  });

  group('NetworkException', () {
    test('should be a subclass of AppException', () {
      const exception = NetworkException();
      expect(exception, isA<AppException>());
    });

    test('should be a subclass of Equatable', () {
      const exception = NetworkException();
      expect(exception, isA<Equatable>());
    });

    test('should implement Exception', () {
      const exception = NetworkException();
      expect(exception, isA<Exception>());
    });

    test('should have default message', () {
      const exception = NetworkException();
      expect(exception.message, 'No internet connection. Please check your network.');
    });

    test('should support custom message', () {
      const exception = NetworkException(message: 'Custom network error');
      expect(exception.message, 'Custom network error');
    });

    test('should support equality with default message', () {
      const exception1 = NetworkException();
      const exception2 = NetworkException();
      
      expect(exception1, equals(exception2));
    });

    test('should support equality with custom message', () {
      const exception1 = NetworkException(message: 'Custom error');
      const exception2 = NetworkException(message: 'Custom error');
      
      expect(exception1, equals(exception2));
    });

    test('should support inequality with different messages', () {
      const exception1 = NetworkException();
      const exception2 = NetworkException(message: 'Custom error');
      
      expect(exception1, isNot(equals(exception2)));
    });

    test('should handle empty custom message', () {
      const exception = NetworkException(message: '');
      expect(exception.message, '');
    });
  });

  group('Exception hierarchy', () {
    test('should allow type checking', () {
      const appException = AppException(message: 'App error');
      const serverException = ServerException(message: 'Server error');
      const networkException = NetworkException();

      expect(appException is AppException, isTrue);
      expect(serverException is AppException, isTrue);
      expect(networkException is AppException, isTrue);
      
      expect(serverException is ServerException, isTrue);
      expect(networkException is NetworkException, isTrue);
      
      expect(appException is ServerException, isFalse);
      expect(appException is NetworkException, isFalse);
    });

    test('should allow pattern matching', () {
      const serverException = ServerException(message: 'Server error');
      const networkException = NetworkException();

      String result;
      switch (serverException) {
        case ServerException(message: final message):
          result = 'Server: $message';
          break;
        case NetworkException(message: final message):
          result = 'Network: $message';
          break;
        case AppException(message: final message):
          result = 'App: $message';
          break;
      }
      expect(result, 'Server: Server error');

      switch (networkException) {
        case ServerException(message: final message):
          result = 'Server: $message';
          break;
        case NetworkException(message: final message):
          result = 'Network: $message';
          break;
        case AppException(message: final message):
          result = 'App: $message';
          break;
      }
      expect(result, 'Network: No internet connection. Please check your network.');
    });
  });
}
