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

      if (!_importsDartz(unit)) return;

      reporter.atNode(node, _code);
    });
  }

  bool _isFunctionExpression(Expression expr) {
    return expr is FunctionExpression ||
        (expr is ParenthesizedExpression &&
            _isFunctionExpression(expr.expression));
  }

  bool _importsDartz(AstNode unit) {
    if (unit is! CompilationUnit) return false;
    for (final directive in unit.directives) {
      if (directive is ImportDirective) {
        final uri = directive.uri.stringValue;
        if (uri != null && uri.startsWith('package:dartz')) return true;
      }
    }
    return false;
  }
}
