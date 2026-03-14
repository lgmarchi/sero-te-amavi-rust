/// Base type for all failures in the application.
///
/// Use Result (Either Failure T) instead of throwing exceptions.
/// Failures are explicit and composable, similar to Rust's Result type.
sealed class Failure {
  const Failure(this.message, {this.code, this.cause});

  final String message;
  final String? code;
  final Object? cause;

  @override
  String toString() =>
      'Failure($runtimeType: $message${code != null ? ', code: $code' : ''}${cause != null ? ', cause: $cause' : ''})';
}

/// Network/connectivity failure (timeout, no connection, etc.).
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code, super.cause});
}

/// Resource not found (404).
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code, super.cause});
}

/// Unauthorized (401) or Forbidden (403).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.code, super.cause});
}

/// Validation error (400, invalid input).
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code, super.cause});
}

/// Server error (5xx).
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code, super.cause});
}

/// Unknown or unexpected error.
class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code, super.cause});
}
