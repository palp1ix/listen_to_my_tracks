import 'package:flutter_test/flutter_test.dart';
import 'package:listen_to_my_tracks/core/error/exception.dart';
import 'package:listen_to_my_tracks/core/utils/result.dart';
import 'package:equatable/equatable.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should be a subclass of Result', () {
        const success = Success<String, AppException>('test');
        expect(success, isA<Result<String, AppException>>());
      });

      test('should be a subclass of Equatable', () {
        const success = Success<String, AppException>('test');
        expect(success, isA<Equatable>());
      });

      test('should have correct value', () {
        const success = Success<String, AppException>('test');
        expect(success.value, 'test');
      });

      test('should support equality', () {
        const success1 = Success<String, AppException>('test');
        const success2 = Success<String, AppException>('test');
        
        expect(success1, equals(success2));
      });

      test('should support inequality', () {
        const success1 = Success<String, AppException>('test');
        const success2 = Success<String, AppException>('different');
        
        expect(success1, isNot(equals(success2)));
      });

      test('should work with different types', () {
        const intSuccess = Success<int, AppException>(42);
        const boolSuccess = Success<bool, AppException>(true);
        const listSuccess = Success<List<String>, AppException>(['a', 'b', 'c']);

        expect(intSuccess.value, 42);
        expect(boolSuccess.value, true);
        expect(listSuccess.value, ['a', 'b', 'c']);
      });

      test('should work with null values', () {
        const nullSuccess = Success<String?, AppException>(null);
        expect(nullSuccess.value, isNull);
      });
    });

    group('Failure', () {
      test('should be a subclass of Result', () {
        const failure = Failure<String, ServerException>(
          ServerException(message: 'Server error'),
        );
        expect(failure, isA<Result<String, ServerException>>());
      });

      test('should be a subclass of Equatable', () {
        const failure = Failure<String, ServerException>(
          ServerException(message: 'Server error'),
        );
        expect(failure, isA<Equatable>());
      });

      test('should have correct exception', () {
        const serverException = ServerException(message: 'Server error');
        const failure = Failure<String, ServerException>(serverException);
        
        expect(failure.exception, serverException);
      });

      test('should support equality', () {
        const serverException = ServerException(message: 'Server error');
        const failure1 = Failure<String, ServerException>(serverException);
        const failure2 = Failure<String, ServerException>(serverException);
        
        expect(failure1, equals(failure2));
      });

      test('should support inequality', () {
        const serverException1 = ServerException(message: 'Server error');
        const serverException2 = ServerException(message: 'Different error');
        const failure1 = Failure<String, ServerException>(serverException1);
        const failure2 = Failure<String, ServerException>(serverException2);
        
        expect(failure1, isNot(equals(failure2)));
      });

      test('should work with different exception types', () {
        const serverException = ServerException(message: 'Server error');
        const networkException = NetworkException();
        
        const serverFailure = Failure<String, ServerException>(serverException);
        const networkFailure = Failure<String, NetworkException>(networkException);

        expect(serverFailure.exception, serverException);
        expect(networkFailure.exception, networkException);
      });
    });

    group('Type checking', () {
      test('should allow checking if result is Success', () {
        const success = Success<String, AppException>('test');
        const failure = Failure<String, AppException>(
          ServerException(message: 'error'),
        );

        expect(success is Success<String, AppException>, isTrue);
        expect(success is Failure<String, AppException>, isFalse);
        expect(failure is Success<String, AppException>, isFalse);
        expect(failure is Failure<String, AppException>, isTrue);
      });

      test('should allow pattern matching', () {
        const success = Success<String, AppException>('test');
        const failure = Failure<String, AppException>(
          ServerException(message: 'error'),
        );

        String result;
        switch (success) {
          case Success<String, AppException>(value: final value):
            result = value;
            break;
          case Failure<String, AppException>():
            result = 'error';
            break;
        }
        expect(result, 'test');

        switch (failure) {
          case Success<String, AppException>():
            result = 'success';
            break;
          case Failure<String, AppException>(exception: final exception):
            result = exception.message;
            break;
        }
        expect(result, 'error');
      });
    });
  });
}
