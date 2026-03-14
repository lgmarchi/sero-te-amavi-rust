import 'package:dartz/dartz.dart';

/// Rust-style Option constructors. Use [Some] and [None] instead of [some] and [none].
/// [None] is assignable to any [Option<T>] (like Rust).

/// Creates [Option<T>] with a value (Rust: `Some(10)`).
Option<T> Some<T>(T value) => some(value);

/// [Option] with no value (Rust: `None`). Assignable to any [Option<T>].
Option<Never> get None => none();

/// Rust-style Either/Result constructors. Use [Ok] and [Err] instead of [Right] and [Left].
/// [Ok] and [Err] are assignable to any [Either<L, R>] (like Rust).

/// Creates [Either<Never, R>] (success). Assignable to [Either<L, R>] for any L.
Either<Never, R> Ok<R>(R value) => Right<Never, R>(value);

/// Creates [Either<L, Never>] (error). Assignable to [Either<L, R>] for any R.
Either<L, Never> Err<L>(L error) => Left<L, Never>(error);

/// Converts nullable to Option. Use for fromJson and interop with nullable APIs.
Option<T> optionOf<T>(T? value) => value != null ? some(value) : none();

/// Extension on T? to map over the inner value if present (Rust-style).
/// Like Rust's Option::map but for nullable: `nullable.mapOption((x) => f(x))` returns Option<R>.
extension NullableMapOption<T> on T? {
  Option<R> mapOption<R>(R Function(T) f) =>
      this != null ? some(f(this as T)) : none();
}
