import 'dart:convert';

import 'package:injectable/injectable.dart';

/// Result of JSON validation.
class JsonValidationResult {
  const JsonValidationResult({
    required this.isValid,
    this.errorMessage,
    this.errorOffset,
  });

  final bool isValid;
  final String? errorMessage;
  final int? errorOffset;

  static const valid = JsonValidationResult(isValid: true);
}

/// Pure Dart service for JSON formatting operations.
@lazySingleton
class JsonFormatterService {
  /// Prettify JSON with given indent.
  String prettify(String input, {int indent = 2}) {
    final parsed = jsonDecode(input);
    final encoder = JsonEncoder.withIndent(' ' * indent);
    return encoder.convert(parsed);
  }

  /// Minify JSON (remove whitespace).
  String minify(String input) {
    final parsed = jsonDecode(input);
    return jsonEncode(parsed);
  }

  /// Validate JSON and return result with error details.
  JsonValidationResult validate(String input) {
    if (input.trim().isEmpty) {
      return const JsonValidationResult(
        isValid: false,
        errorMessage: 'Empty input',
      );
    }

    try {
      jsonDecode(input);
      return JsonValidationResult.valid;
    } on FormatException catch (e) {
      return JsonValidationResult(
        isValid: false,
        errorMessage: e.message,
        errorOffset: e.offset,
      );
    }
  }

  /// Calculate error line/column from offset.
  ({int line, int column}) errorPosition(String input, int offset) {
    int line = 1;
    int column = 1;
    for (int i = 0; i < offset && i < input.length; i++) {
      if (input[i] == '\n') {
        line++;
        column = 1;
      } else {
        column++;
      }
    }
    return (line: line, column: column);
  }
}
