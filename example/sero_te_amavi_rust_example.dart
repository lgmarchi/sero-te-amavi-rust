// ignore_for_file: avoid_print

import 'package:sero_te_amavi_rust/sero_te_amavi_rust.dart';

void main() {
  print('=== Option examples ===\n');
  optionExamples();

  print('\n=== Either / Result examples ===\n');
  eitherExamples();

  print('\n=== Real-world patterns ===\n');
  realWorldPatterns();
}

void optionExamples() {
  // Rust-style constructors: Some, None
  final someOpt = Some(42);
  final noneOpt = none<int>();
  // match (none/some)
  print(
      'match some: ${someOpt.match(none: () => 'absent', some: (v) => v.toString())}');
  print(
      'match none: ${noneOpt.match(none: () => 'absent', some: (v) => v.toString())}');

  // unwrap, unwrapOr, unwrapOrDefault
  print('unwrap: ${someOpt.unwrap()}');
  print('unwrapOr (some): ${someOpt.unwrapOr(0)}');
  print('unwrapOr (none): ${noneOpt.unwrapOr(0)}');
  final optInt = Some(10);
  final optStr = Some('hello');
  print('unwrapOrDefault int: ${optInt.unwrapOrDefault()}');
  print('unwrapOrDefault String: ${optStr.unwrapOrDefault()}');
  print('unwrapOrDefault List: ${none<List<int>>().unwrapOrDefault()}');

  // isSome, isNone
  print('isSome (some): ${someOpt.isSome()}, isNone: ${someOpt.isNone()}');
  print('isSome (none): ${noneOpt.isSome()}, isNone: ${noneOpt.isNone()}');

  // ifSome
  someOpt.ifSome((v) => print('ifSome: $v'));
  noneOpt.ifSome((v) => print('never')); // does not run

  // toNullable, let
  print('toNullable (some): ${someOpt.toNullable()}');
  print('toNullable (none): ${noneOpt.toNullable()}');
  print('let (some): ${someOpt.let((v) => v * 2)}');
  print('let (none): ${noneOpt.let((v) => v * 2) ?? 'null'}');

  // expect (custom panic message when None)
  print('expect (some): ${someOpt.expect('value was None')}');
  // noneOpt.expect('oops'); // would throw: "oops"
}

void eitherExamples() {
  // Rust-style constructors: Ok, Err
  final ok = Ok(42);
  final err = Err<String>('something failed');

  // match (err/ok)
  print('match ok: ${ok.match(err: (e) => 0, ok: (v) => v)}');
  print('match err: ${err.match(err: (e) => 0, ok: (v) => v)}');

  // unwrap, unwrapOr, unwrapOrDefault
  print('unwrap ok: ${ok.unwrap()}');
  print('unwrapOr (ok): ${ok.unwrapOr(0)}');
  final eitherInt = Ok(7);
  print('unwrapOrDefault: ${eitherInt.unwrapOrDefault()}');

  // isOk, isErr
  print('isOk (ok): ${ok.isOk}, isErr: ${ok.isErr}');
  print('isOk (err): ${err.isOk}, isErr: ${err.isErr}');

  // ifOk, ifErr
  ok.ifOk((v) => print('ifOk: $v'));
  err.ifErr((e) => print('ifErr: $e'));

  // expect (custom panic message when Err)
  print('expect (ok): ${ok.expect('operation failed')}');
  // err.expect('oops'); // would throw: "oops"

  // mapErr (transform error type)
  final mapped = err.mapErr((e) => 'Error: $e');
  print('mapErr: ${mapped.match(err: (e) => e, ok: (v) => v.toString())}');
}

void realWorldPatterns() {
  // Repository-style Result<Option<Entity>> (getById)
  Either<String, Option<Map<String, dynamic>>> getById(String id) {
    if (id == 'missing') return Ok(none<Map<String, dynamic>>());
    if (id == 'error') return Err('DB error');
    return Ok(Some({'id': id, 'name': 'Entity'}));
  }

  getById('valid').match(
    err: (e) => print('getById error: $e'),
    ok: (opt) => opt.match(
      none: () => print('getById: not found'),
      some: (entity) => print('getById: ${entity['name']}'),
    ),
  );

  getById('missing').match(
    err: (e) => print('getById error: $e'),
    ok: (opt) => opt.match(
      none: () => print('getById: not found'),
      some: (entity) => print('getById: ${entity['name']}'),
    ),
  );

  getById('error').match(
    err: (e) => print('getById error: $e'),
    ok: (opt) => opt.match(
      none: () => print('getById: not found'),
      some: (entity) => print('getById: ${entity['name']}'),
    ),
  );

  // Chaining Option with let
  final maybeLength = Some('hello').let((s) => s.length);
  print('let chain: $maybeLength');

  // Error handling flow with match
  final result = Ok(100);
  final message = result.match(
    err: (e) => 'Error: $e',
    ok: (v) => 'Value: $v',
  );
  print('match result: $message');
}
