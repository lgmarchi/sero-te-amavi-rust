# sero_te_amavi_rust

Rust-like extensions for [dartz](https://pub.dev/packages/dartz): `match`, `unwrap`, `ifSome`, `ifOk`, `ifErr`, `isSome`, `isNone`, `isOk`, `isErr`.

Named after St. Augustine, *Confessions*: **"Sero te amavi"** — *Late have I loved you*.

## Installation

```yaml
dependencies:
  dartz: ^0.10.1
  sero_te_amavi_rust: ^1.0.0
```

## Rust-style constructors

Use `Some`, `None`, `Ok`, and `Err` for a Rust-like feel:

| Constructor | Description |
|-------------|-------------|
| `Some(value)` | Option with a value |
| `None` | Option with no value (assignable to any `Option<T>`) |
| `Ok(value)` | Either success (Right) |
| `Err(error)` | Either failure (Left) |

## Option (dartz)

| API | Description |
|-----|-------------|
| `match(none:, some:)` | Pattern match (Rust-style) |
| `unwrap()` | Value or throws if None |
| `expect(msg)` | Like unwrap, custom panic message when None |
| `unwrapOr(T)` | Value or default |
| `unwrapOrDefault()` | For int, double, bool, String, List, Map |
| `isSome` / `isNone` | Boolean getters |
| `ifSome((T) => void)` | "if let Some" — run only when Some |
| `toNullable()` | Returns T? |
| `let<R>((T) => R)` | Transform when Some; returns R? |

## Either / Result (dartz)

Works with `Either<L, R>` (e.g. `Result<T> = Either<Failure, T>`).

| API | Description |
|-----|-------------|
| `match(err:, ok:)` | Pattern match (L=err, R=ok) |
| `unwrap()` | R or throws if Left |
| `expect(msg)` | Like unwrap, custom panic message when Left |
| `mapErr((L) => L2)` | Maps the Left (error) side |
| `unwrapOr(R)` | R or default if Left |
| `unwrapOrDefault()` | For Either<L, int>, etc. |
| `isOk` / `isErr` | Boolean getters |
| `ifOk((R) => void)` | "if let Ok" |
| `ifErr((L) => void)` | "if let Err" |

## Example

Run the bundled example:

```bash
dart run example/sero_te_amavi_rust_example.dart
```

It demonstrates `match`, `unwrap`, `unwrapOr`, `unwrapOrDefault`, `isSome`, `isNone`, `ifSome`, `toNullable`, `let` for Option; and `match`, `unwrap`, `unwrapOr`, `isOk`, `isErr`, `ifOk`, `ifErr` for Either, plus repository-style `Result<Option<Entity>>` patterns.

## Testing

From the package root:

```bash
dart test
```

## Rust-style constructors

Use `Some`, `None`, `Ok`, and `Err` for a Rust-like API:

```dart
import 'package:sero_te_amavi_rust/sero_te_amavi_rust.dart';

// Option (Rust: Some(10), None)
final opt = Some(42);
final absent = None;
opt.ifSome((v) => print(v));
if (opt.isSome) { /* ... */ }
final n = opt.unwrapOrDefault();

// Either / Result (Rust: Ok(42), Err("fail"))
final result = Ok(100);
final failure = Err<String>('something went wrong');
result.ifOk((v) => print(v));
failure.ifErr((e) => print(e));
if (result.isOk) { /* ... */ }
result.match(err: (e) => 0, ok: (v) => v);

// expect: unwrap with custom panic message
final v = Some(10).expect('value required');
final r = Ok(42).expect('expected success');

// mapErr: transform the error side
final mapped = Err<int>(404).mapErr((code) => 'HTTP $code');
// mapped is Err('HTTP 404')
```

## Lint (sero_te_amavi_rust_lint)

Optional custom lint to enforce `match` instead of `fold` on Option and Either. Configure severity in your `analysis_options.yaml`:

```yaml
dev_dependencies:
  custom_lint: ^0.8.0
  sero_te_amavi_rust_lint:
    git:
      url: https://github.com/catholic-verse-studios/sero_te_amavi_rust.git
      path: packages/sero_te_amavi_rust_lint
      ref: main

analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    - use_match_instead_of_fold: error   # or warning
```

## License

MIT
