import 'package:equatable/equatable.dart';

/// Events for the JSON Formatter BLoC.
abstract class JsonFormatterEvent extends Equatable {
  const JsonFormatterEvent();

  @override
  List<Object?> get props => [];
}

/// Input text changed.
class JsonInputChanged extends JsonFormatterEvent {
  const JsonInputChanged(this.input);
  final String input;

  @override
  List<Object?> get props => [input];
}

/// Prettify the current input.
class JsonPrettifyRequested extends JsonFormatterEvent {
  const JsonPrettifyRequested();
}

/// Minify the current input.
class JsonMinifyRequested extends JsonFormatterEvent {
  const JsonMinifyRequested();
}

/// Clear input and output.
class JsonClearRequested extends JsonFormatterEvent {
  const JsonClearRequested();
}

/// Change indent size.
class JsonIndentChanged extends JsonFormatterEvent {
  const JsonIndentChanged(this.indent);
  final int indent;

  @override
  List<Object?> get props => [indent];
}

/// Paste from clipboard.
class JsonPasteRequested extends JsonFormatterEvent {
  const JsonPasteRequested(this.text);
  final String text;

  @override
  List<Object?> get props => [text];
}

/// Load a sample JSON for demo.
class JsonSampleRequested extends JsonFormatterEvent {
  const JsonSampleRequested();
}
