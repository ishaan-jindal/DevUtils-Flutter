import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../services/json_formatter_service.dart';
import 'json_formatter_event.dart';
import 'json_formatter_state.dart';

/// BLoC for JSON Formatter feature.
@injectable
class JsonFormatterBloc extends Bloc<JsonFormatterEvent, JsonFormatterState> {
  JsonFormatterBloc(this._service) : super(const JsonFormatterState()) {
    on<JsonInputChanged>(_onInputChanged);
    on<JsonPrettifyRequested>(_onPrettify);
    on<JsonMinifyRequested>(_onMinify);
    on<JsonClearRequested>(_onClear);
    on<JsonIndentChanged>(_onIndentChanged);
    on<JsonPasteRequested>(_onPaste);
    on<JsonSampleRequested>(_onSample);
  }

  final JsonFormatterService _service;

  void _onInputChanged(
    JsonInputChanged event,
    Emitter<JsonFormatterState> emit,
  ) {
    final input = event.input;
    if (input.trim().isEmpty) {
      emit(const JsonFormatterState());
      return;
    }

    final result = _service.validate(input);
    if (result.isValid) {
      emit(
        state.copyWith(
          input: input,
          isValid: true,
          isEmpty: false,
          clearError: true,
        ),
      );
    } else {
      int? line;
      int? column;
      if (result.errorOffset != null) {
        final pos = _service.errorPosition(input, result.errorOffset!);
        line = pos.line;
        column = pos.column;
      }
      emit(
        state.copyWith(
          input: input,
          isValid: false,
          isEmpty: false,
          errorMessage: result.errorMessage,
          errorLine: line,
          errorColumn: column,
        ),
      );
    }
  }

  void _onPrettify(
    JsonPrettifyRequested event,
    Emitter<JsonFormatterState> emit,
  ) {
    if (state.input.trim().isEmpty || !state.isValid) return;
    try {
      final output = _service.prettify(state.input, indent: state.indentSize);
      emit(state.copyWith(output: output));
    } catch (_) {
      // Already handled by validation
    }
  }

  void _onMinify(JsonMinifyRequested event, Emitter<JsonFormatterState> emit) {
    if (state.input.trim().isEmpty || !state.isValid) return;
    try {
      final output = _service.minify(state.input);
      emit(state.copyWith(output: output));
    } catch (_) {
      // Already handled by validation
    }
  }

  void _onClear(JsonClearRequested event, Emitter<JsonFormatterState> emit) {
    emit(const JsonFormatterState());
  }

  void _onIndentChanged(
    JsonIndentChanged event,
    Emitter<JsonFormatterState> emit,
  ) {
    emit(state.copyWith(indentSize: event.indent));

    // Re-format if we have valid output
    if (state.isValid && state.output.isNotEmpty) {
      try {
        final output = _service.prettify(state.input, indent: event.indent);
        emit(state.copyWith(output: output));
      } catch (_) {}
    }
  }

  void _onPaste(JsonPasteRequested event, Emitter<JsonFormatterState> emit) {
    add(JsonInputChanged(event.text));
  }

  void _onSample(JsonSampleRequested event, Emitter<JsonFormatterState> emit) {
    const sample = '''
{
  "name": "DevUtils",
  "version": "1.0.0",
  "description": "A developer utility toolbox",
  "features": [
    "JSON Formatter",
    "JWT Decoder",
    "Regex Tester"
  ],
  "config": {
    "darkMode": true,
    "offline": true,
    "rating": 4.9
  },
  "tags": null
}''';
    add(const JsonInputChanged(sample));
  }
}
