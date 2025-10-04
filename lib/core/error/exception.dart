import 'package:equatable/equatable.dart';

// A base class for custom exceptions in the application.
// This allows for more specific error handling than generic Exception types.
class AppException extends Equatable implements Exception {
  const AppException({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

// Thrown when the server returns a non-200 status code.
class ServerException extends AppException {
  const ServerException({required super.message});
}

// Thrown for network-related issues, like no internet connection.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
  });
}
