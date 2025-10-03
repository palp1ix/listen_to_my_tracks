import 'package:listen_to_my_tracks/core/error/exception.dart';

// A sealed class to represent the result of an operation that can either
// succeed with a value of type [S] or fail with an error of type [E].
sealed class Result<S, E extends AppException> {
  const Result();
}

// Represents a successful result.
final class Success<S, E extends AppException> extends Result<S, E> {
  const Success(this.value);
  final S value;
}

// Represents a failure result.
final class Failure<S, E extends AppException> extends Result<S, E> {
  const Failure(this.exception);
  final E exception;
}
