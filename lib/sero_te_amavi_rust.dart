/// Rust-like extensions for dartz (Option and Either).
///
/// Named after St. Augustine, _Confessions_: "Sero te amavi" (Late have I loved you).
library sero_te_amavi_rust;

import 'package:dartz/dartz.dart';

import 'src/failure.dart';

// Export Option, Either, Right, Left from dartz; hide constructors to use our Some/None.
// Hide State so Flutter apps (StatefulWidget) don't get a name collision with dartz's State monad.
// Hide optionOf from dartz since constructors.dart re-exports a compatible version.
export 'package:dartz/dartz.dart' hide None, Some, State, optionOf;

export 'src/constructors.dart';
export 'src/option_extensions.dart';
export 'src/either_extensions.dart';
export 'src/failure.dart';

/// Result type: Right = success, Left = failure.
///
/// Use instead of throwing exceptions. Similar to Rust's Result type.
/// - Right(T) = success with value T
/// - Left(Failure) = failure with Failure
///
/// Extensions (match, unwrap, isOk, isErr, ifOk, ifErr, etc.) come from this package.
typedef Result<T> = Either<Failure, T>;

/// Convenience constructors and Result-specific helpers.
extension ResultX<T> on Result<T> {
  T? get valueOrNull => fold((Failure l) => null, (T r) => r);
  Failure? get failureOrNull => fold((Failure l) => l, (T r) => null);
}

/// Build Right(result) - success.
Result<T> success<T>(T value) => Right(value);

/// Build Left(failure) - error.
Result<T> failure<T>(Failure f) => Left(f);
