import 'package:dartz/dartz.dart' hide Some, None;
import 'package:sero_te_amavi_rust/sero_te_amavi_rust.dart';
import 'package:test/test.dart';

void main() {
  group('Some', () {
    test('creates Option with value', () {
      final opt = Some(42);
      expect(opt.isSome(), true);
      expect(opt.unwrap(), 42);
    });
    test('equivalent to some()', () {
      expect(Some(10).unwrap(), some(10).unwrap());
    });
  });

  group('None', () {
    test('creates Option with no value', () {
      final Option<int> opt = None;
      expect(opt.isNone(), true);
    });
    test('unwrapOr returns default', () {
      expect(none<int>().unwrapOr(0), 0);
    });
    test('assignable to Option<int>', () {
      Option<int> opt = None;
      expect(opt.isNone(), true);
    });
    test('assignable to Option<String>', () {
      Option<String> opt = None;
      expect(opt.isNone(), true);
    });
  });

  group('Ok', () {
    test('creates Either Right', () {
      final e = Ok(42);
      expect(e.isOk, true);
      expect(e.unwrap(), 42);
    });
    test('assignable to Either<String, int>', () {
      Either<String, int> result = Ok(10);
      expect(result.unwrap(), 10);
    });
  });

  group('Err', () {
    test('creates Either Left', () {
      final Either<String, int> e = Err('failed');
      expect(e.isErr, true);
      expect(e.unwrapOr(0), 0);
    });
    test('assignable to Either<String, int>', () {
      Either<String, int> result = Err('error');
      expect(result.isErr, true);
      expect(result.unwrapOr(99), 99);
    });
  });
}
