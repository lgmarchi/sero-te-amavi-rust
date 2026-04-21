import 'package:dartz/dartz.dart';

/// Rust-like match for Either (L = err, R = ok). Use with Result = Either<Failure, T>.
extension EitherMatch<L, R> on Either<L, R> {
  R2 match<R2>({
    required R2 Function(L) err,
    required R2 Function(R) ok,
  }) =>
      fold(err, ok);
}

/// Returns the right value or throws if Left. Prefer [match] for explicit handling.
extension EitherUnwrap<L, R> on Either<L, R> {
  R unwrap() => fold(
        (l) => throw StateError('Either is Left: $l'),
        (r) => r,
      );
}

/// Like [unwrap] but throws with [message] when Left (Rust: expect).
extension EitherExpect<L, R> on Either<L, R> {
  R expect(String message) => fold(
        (_) => throw StateError(message),
        (r) => r,
      );
}

/// Maps the Left (error) side. Right is unchanged (Rust: map_err).
extension EitherMapErr<L, R> on Either<L, R> {
  Either<L2, R> mapErr<L2>(L2 Function(L) f) => fold(
        (l) => Left<L2, R>(f(l)),
        (r) => Right<L2, R>(r),
      );
}

/// Returns the right value or [defaultValue] when Left.
extension EitherUnwrapOr<L, R> on Either<L, R> {
  R unwrapOr(R defaultValue) => fold((_) => defaultValue, (v) => v);
}

/// Boolean checks: isOk / isErr (Rust-style).
extension EitherChecks<L, R> on Either<L, R> {
  bool get isOk => isRight();
  bool get isErr => isLeft();
}

/// "if let Ok" — runs [f] only when Either is Right.
extension EitherIfOk<L, R> on Either<L, R> {
  void ifOk(void Function(R) f) => fold((_) {}, f);
}

/// "if let Err" — runs [f] only when Either is Left.
extension EitherIfErr<L, R> on Either<L, R> {
  void ifErr(void Function(L) f) => fold(f, (_) {});
}

/// unwrapOrDefault for Either with primitive right type.
extension EitherInt<L> on Either<L, int> {
  int unwrapOrDefault() => fold((_) => 0, (v) => v);
}

extension EitherDouble<L> on Either<L, double> {
  double unwrapOrDefault() => fold((_) => 0.0, (v) => v);
}

extension EitherBool<L> on Either<L, bool> {
  bool unwrapOrDefault() => fold((_) => false, (v) => v);
}

extension EitherString<L> on Either<L, String> {
  String unwrapOrDefault() => fold((_) => '', (v) => v);
}

extension EitherList<L, E> on Either<L, List<E>> {
  List<E> unwrapOrDefault() => fold((_) => [], (v) => v);
}

extension EitherMap<L, K, V> on Either<L, Map<K, V>> {
  Map<K, V> unwrapOrDefault() => fold((_) => {}, (v) => v);
}
