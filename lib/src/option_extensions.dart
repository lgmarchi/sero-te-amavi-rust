import 'package:dartz/dartz.dart';

/// Rust-like match for Option. Prefer over [fold] for readability.
extension OptionMatch<T> on Option<T> {
  R match<R>({
    required R Function() none,
    required R Function(T) some,
  }) =>
      fold(none, some);
}

/// Returns the value or throws if None (use only when you know it's Some).
/// Prefer [match] for explicit handling.
extension OptionUnwrap<T> on Option<T> {
  T unwrap() => fold(
        () => throw StateError('Option is None'),
        (v) => v,
      );
}

/// Like [unwrap] but throws with [message] when None (Rust: expect).
extension OptionExpect<T> on Option<T> {
  T expect(String message) => fold(
        () => throw StateError(message),
        (v) => v,
      );
}

/// Returns the value or the provided default if None.
extension OptionUnwrapOr<T> on Option<T> {
  T unwrapOr(T defaultValue) => getOrElse(() => defaultValue);
}

/// "if let Some" — runs [f] only when Option is Some.
extension OptionIfSome<T> on Option<T> {
  void ifSome(void Function(T) f) => fold(() {}, f);
}

/// Returns T? (null when None). Useful for interop with nullable APIs.
extension OptionToNullable<T> on Option<T> {
  T? toNullable() => fold(() => null, (v) => v);
}

/// Transforms when Some; returns null when None. Like Rust's [and_then] + [map] for a single value.
extension OptionLet<T> on Option<T> {
  R? let<R>(R Function(T) f) => fold(() => null, f);
}

/// unwrapOrDefault for primitive types.
extension OptionInt on Option<int> {
  int unwrapOrDefault() => getOrElse(() => 0);
}

extension OptionDouble on Option<double> {
  double unwrapOrDefault() => getOrElse(() => 0.0);
}

extension OptionBool on Option<bool> {
  bool unwrapOrDefault() => getOrElse(() => false);
}

extension OptionString on Option<String> {
  String unwrapOrDefault() => getOrElse(() => '');
}

extension OptionList<E> on Option<List<E>> {
  List<E> unwrapOrDefault() => getOrElse(() => []);
}

extension OptionMap<K, V> on Option<Map<K, V>> {
  Map<K, V> unwrapOrDefault() => getOrElse(() => {});
}
