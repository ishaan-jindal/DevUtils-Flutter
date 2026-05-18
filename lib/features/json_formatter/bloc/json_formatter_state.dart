import 'package:equatable/equatable.dart';

/// State for the JSON Formatter BLoC.
class JsonFormatterState extends Equatable {
  const JsonFormatterState({
    this.input = '',
    this.output = '',
    this.isValid = false,
    this.isEmpty = true,
    this.errorMessage,
    this.errorLine,
    this.errorColumn,
    this.indentSize = 2,
  });

  final String input;
  final String output;
  final bool isValid;
  final bool isEmpty;
  final String? errorMessage;
  final int? errorLine;
  final int? errorColumn;
  final int indentSize;

  JsonFormatterState copyWith({
    String? input,
    String? output,
    bool? isValid,
    bool? isEmpty,
    String? errorMessage,
    int? errorLine,
    int? errorColumn,
    int? indentSize,
    bool clearError = false,
  }) {
    return JsonFormatterState(
      input: input ?? this.input,
      output: output ?? this.output,
      isValid: isValid ?? this.isValid,
      isEmpty: isEmpty ?? this.isEmpty,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorLine: clearError ? null : (errorLine ?? this.errorLine),
      errorColumn: clearError ? null : (errorColumn ?? this.errorColumn),
      indentSize: indentSize ?? this.indentSize,
    );
  }

  @override
  List<Object?> get props => [
    input,
    output,
    isValid,
    isEmpty,
    errorMessage,
    errorLine,
    errorColumn,
    indentSize,
  ];
}
