import 'package:sero_te_amavi_rust/sero_te_amavi_rust.dart';
import 'package:test/test.dart';

void main() {
  group('Option match', () {
    test('some returns some branch', () {
      final opt = some(42);
      expect(opt.match(none: () => 0, some: (v) => v), 42);
    });
    test('none returns none branch', () {
      final opt = none<int>();
      expect(opt.match(none: () => 0, some: (v) => v), 0);
    });
  });

  group('Option unwrap', () {
    test('some returns value', () {
      expect(some(42).unwrap(), 42);
    });
    test('none throws StateError', () {
      expect(() => none<int>().unwrap(), throwsStateError);
    });
  });

  group('Option expect', () {
    test('some returns value', () {
      expect(some(42).expect('custom msg'), 42);
    });
    test('none throws StateError with message', () {
      expect(
        () => none<int>().expect('value was None'),
        throwsA(isA<StateError>()
            .having((e) => e.message, 'message', 'value was None')),
      );
    });
  });

  group('Option unwrapOr', () {
    test('some returns value', () {
      expect(some(42).unwrapOr(0), 42);
    });
    test('none returns default', () {
      expect(none<int>().unwrapOr(0), 0);
    });
  });

  group('Option unwrapOrDefault', () {
    test('Option<int>', () {
      expect(some(10).unwrapOrDefault(), 10);
      expect(none<int>().unwrapOrDefault(), 0);
    });
    test('Option<double>', () {
      expect(some(3.14).unwrapOrDefault(), 3.14);
      expect(none<double>().unwrapOrDefault(), 0.0);
    });
    test('Option<bool>', () {
      expect(some(true).unwrapOrDefault(), true);
      expect(none<bool>().unwrapOrDefault(), false);
    });
    test('Option<String>', () {
      expect(some('x').unwrapOrDefault(), 'x');
      expect(none<String>().unwrapOrDefault(), '');
    });
    test('Option<List>', () {
      expect(some([1, 2]).unwrapOrDefault(), [1, 2]);
      expect(none<List<int>>().unwrapOrDefault(), []);
    });
    test('Option<Map>', () {
      expect(some({'a': 1}).unwrapOrDefault(), {'a': 1});
      expect(none<Map<String, int>>().unwrapOrDefault(), {});
    });
  });

  group('Option isSome / isNone', () {
    test('some', () {
      final opt = some(1);
      expect(opt.isSome(), true);
      expect(opt.isNone(), false);
    });
    test('none', () {
      final opt = none<int>();
      expect(opt.isSome(), false);
      expect(opt.isNone(), true);
    });
  });

  group('Option ifSome', () {
    test('some runs callback', () {
      var called = false;
      some(42).ifSome((v) {
        expect(v, 42);
        called = true;
      });
      expect(called, true);
    });
    test('none does not run callback', () {
      var called = false;
      none<int>().ifSome((_) => called = true);
      expect(called, false);
    });
  });

  group('Option toNullable', () {
    test('some returns value', () {
      expect(some(42).toNullable(), 42);
    });
    test('none returns null', () {
      expect(none<int>().toNullable(), null);
    });
  });

  group('Option let', () {
    test('some returns transformed value', () {
      expect(some(21).let((v) => v * 2), 42);
    });
    test('none returns null', () {
      expect(none<int>().let((v) => v * 2), null);
    });
  });
}
