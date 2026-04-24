// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => _SeroTeAmaviRustLinter();

class _SeroTeAmaviRustLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        UseMatchInsteadOfFold(),
        AvoidNullValue(),
        AvoidNullableType(),
      ];
}

/// Forbids using [fold] on Option and Either (Result) from dartz.
/// Use [match] instead for better readability (Rust-like ok/err, none/some).
/// Configure severity in analysis_options.yaml: use_match_instead_of_fold: error|warning
class UseMatchInsteadOfFold extends DartLintRule {
  UseMatchInsteadOfFold() : super(code: _code);

  static const _code = LintCode(
    name: 'use_match_instead_of_fold',
    problemMessage: 'Use match instead of fold for Option and Result. Prefer '
        'result.match(err: (f) => ..., ok: (v) => ...) or '
        'option.match(none: () => ..., some: (v) => ...).',
    correctionMessage: 'Replace fold with match.',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      if (node.methodName.name != 'fold') return;
      if (node.argumentList.arguments.length != 2) return;

      // Option/Either fold: both args are functions.
      // Iterable.fold: first arg is typically a value (not a function).
      final firstArg = node.argumentList.arguments[0];
      if (!_isFunctionExpression(firstArg)) return;

      final unit = node.root;

      if (!_importsDartzOrSero(unit)) return;

      reporter.atNode(node, _code);
    });
  }

  bool _isFunctionExpression(Expression expr) {
    return expr is FunctionExpression ||
        (expr is ParenthesizedExpression &&
            _isFunctionExpression(expr.expression));
  }
}

/// Flags usage of `null` literal in files that import dartz or sero_te_amavi_rust.
/// Use `None` from Option instead for type-safe absence.
/// Configure severity in analysis_options.yaml: avoid_null_value: error|warning
class AvoidNullValue extends DartLintRule {
  AvoidNullValue() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_null_value',
    problemMessage: 'Avoid using null. Use None (Option) for type-safe '
        'absence handling. Example: Option<String> name = None;',
    correctionMessage: 'Replace null with None or wrap the value in Option.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addNullLiteral((node) {
      final unit = node.root;
      if (!_importsDartzOrSero(unit)) return;

      reporter.atNode(node, _code);
    });
  }
}

/// Flags nullable type annotations (`Type?`) in files that import dartz or sero_te_amavi_rust.
/// Use `Option<Type>` instead for Rust-like absence semantics.
/// Configure severity in analysis_options.yaml: avoid_nullable_type: error|warning
class AvoidNullableType extends DartLintRule {
  AvoidNullableType() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_nullable_type',
    problemMessage: 'Avoid nullable types (Type?). Use Option<Type> instead '
        'for Rust-like type-safe absence. Example: Option<String> instead of String?.',
    correctionMessage: 'Replace Type? with Option<Type>.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addNamedType((node) {
      if (node.question == null) return;

      final unit = node.root;
      if (!_importsDartzOrSero(unit)) return;

      // Don't flag Option's own type parameter (Option<T> is fine, Option<T?> should flag).
      final parent = node.parent;
      if (parent is TypeArgumentList) {
        final grandparent = parent.parent;
        if (grandparent is NamedType && grandparent.name2.lexeme == 'Option') {
          return;
        }
      }

      reporter.atNode(node, _code);
    });
  }
}

bool _importsDartzOrSero(AstNode unit) {
  if (unit is! CompilationUnit) return false;
  for (final directive in unit.directives) {
    if (directive is ImportDirective) {
      final uri = directive.uri.stringValue;
      if (uri != null &&
          (uri.startsWith('package:dartz') ||
              uri.startsWith('package:sero_te_amavi_rust'))) {
        return true;
      }
    }
  }
  return false;
}
