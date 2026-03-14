import 'package:sero_te_amavi_rust/sero_te_amavi_rust.dart';
import 'package:test/test.dart';

void main() {
  group('Either match', () {
    test('Right returns ok branch', () {
      final e = Right<String, int>(42);
      expect(e.match(err: (l) => 0, ok: (r) => r), 42);
    });
    test('Left returns err branch', () {
      final e = Left<String, int>('fail');
      expect(e.match(err: (l) => l.length, ok: (r) => 0), 4);
    });
  });

  group('Either unwrap', () {
    test('Right returns value', () {
      expect(Right<String, int>(42).unwrap(), 42);
    });
    test('Left throws StateError', () {
      expect(() => Left<String, int>('err').unwrap(), throwsStateError);
    });
  });

  group('Either expect', () {
    test('Right returns value', () {
      expect(Right<String, int>(42).expect('custom msg'), 42);
    });
    test('Left throws StateError with message', () {
      expect(
        () => Left<String, int>('err').expect('operation failed'),
        throwsA(isA<StateError>().having((e) => e.message, 'message', 'operation failed')),
      );
    });
  });

  group('Either mapErr', () {
    test('Right passes through unchanged', () {
      final e = Right<String, int>(42);
      final mapped = e.mapErr((l) => l.length);
      expect(mapped.unwrap(), 42);
    });
    test('Left maps error value', () {
      final e = Left<String, int>('fail');
      final mapped = e.mapErr((l) => l.length);
      expect(mapped.isErr, true);
      expect(mapped.fold((l) => l, (r) => 0), 4);
    });
  });

  group('Either unwrapOr', () {
    test('Right returns value', () {
      expect(Right<String, int>(42).unwrapOr(0), 42);
    });
    test('Left returns default', () {
      expect(Left<String, int>('err').unwrapOr(0), 0);
    });
  });

  group('Either unwrapOrDefault', () {
    test('Either<L, int>', () {
      expect(Right<String, int>(10).unwrapOrDefault(), 10);
      expect(Left<String, int>('x').unwrapOrDefault(), 0);
    });
    test('Either<L, double>', () {
      expect(Right<String, double>(3.14).unwrapOrDefault(), 3.14);
      expect(Left<String, double>('x').unwrapOrDefault(), 0.0);
    });
    test('Either<L, bool>', () {
      expect(Right<String, bool>(true).unwrapOrDefault(), true);
      expect(Left<String, bool>('x').unwrapOrDefault(), false);
    });
    test('Either<L, String>', () {
      expect(Right<String, String>('hi').unwrapOrDefault(), 'hi');
      expect(Left<String, String>('x').unwrapOrDefault(), '');
    });
    test('Either<L, List>', () {
      expect(Right<String, List<int>>([1]).unwrapOrDefault(), [1]);
      expect(Left<String, List<int>>('x').unwrapOrDefault(), []);
    });
    test('Either<L, Map>', () {
      expect(Right<String, Map<String, int>>({'a': 1}).unwrapOrDefault(), {'a': 1});
      expect(Left<String, Map<String, int>>('x').unwrapOrDefault(), {});
    });
  });

  group('Either isOk / isErr', () {
    test('Right', () {
      final e = Right<String, int>(1);
      expect(e.isOk, true);
      expect(e.isErr, false);
    });
    test('Left', () {
      final e = Left<String, int>('x');
      expect(e.isOk, false);
      expect(e.isErr, true);
    });
  });

  group('Either ifOk', () {
    test('Right runs callback', () {
      var called = false;
      Right<String, int>(42).ifOk((v) {
        expect(v, 42);
        called = true;
      });
      expect(called, true);
    });
    test('Left does not run callback', () {
      var called = false;
      Left<String, int>('err').ifOk((_) => called = true);
      expect(called, false);
    });
  });

  group('Either ifErr', () {
    test('Left runs callback', () {
      var called = false;
      Left<String, int>('err').ifErr((e) {
        expect(e, 'err');
        called = true;
      });
      expect(called, true);
    });
    test('Right does not run callback', () {
      var called = false;
      Right<String, int>(42).ifErr((_) => called = true);
      expect(called, false);
    });
  });
}
