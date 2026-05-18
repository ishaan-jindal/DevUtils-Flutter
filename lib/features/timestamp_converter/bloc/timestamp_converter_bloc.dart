import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'timestamp_converter_state.dart';
part 'timestamp_converter_event.dart';

/// BLoC for Timestamp Converter feature
@injectable
class TimestampConverterBloc
    extends Bloc<TimestampConverterEvent, TimestampConverterState> {
  TimestampConverterBloc() : super(const TimestampConverterState()) {
    on<TimestampInputChanged>(_onInputChanged);
    on<TimestampModeChanged>(_onModeChanged);
    on<TimestampNowRequested>(_onNowRequested);
    on<TimestampClearRequested>(_onClear);
  }

  void _onInputChanged(
    TimestampInputChanged event,
    Emitter<TimestampConverterState> emit,
  ) {
    final input = event.input;
    if (input.trim().isEmpty) {
      emit(state.copyWith(input: '', clearError: true, clearDateTime: true));
      return;
    }

    final val = int.tryParse(input.trim());
    if (val == null) {
      emit(
        state.copyWith(
          input: input,
          error: 'Invalid integer',
          clearDateTime: true,
        ),
      );
      return;
    }

    try {
      final dt = state.isMilliseconds
          ? DateTime.fromMillisecondsSinceEpoch(val)
          : DateTime.fromMillisecondsSinceEpoch(val * 1000);
      emit(state.copyWith(input: input, dateTime: dt, clearError: true));
    } catch (e) {
      emit(
        state.copyWith(
          input: input,
          error: 'Invalid timestamp',
          clearDateTime: true,
        ),
      );
    }
  }

  void _onModeChanged(
    TimestampModeChanged event,
    Emitter<TimestampConverterState> emit,
  ) {
    emit(state.copyWith(isMilliseconds: event.isMilliseconds));
    add(
      TimestampInputChanged(state.input),
    ); // Re-evaluate current input with new mode
  }

  void _onNowRequested(
    TimestampNowRequested event,
    Emitter<TimestampConverterState> emit,
  ) {
    final now = DateTime.now();
    final val = state.isMilliseconds
        ? now.millisecondsSinceEpoch
        : now.millisecondsSinceEpoch ~/ 1000;
    add(TimestampInputChanged(val.toString()));
  }

  void _onClear(
    TimestampClearRequested event,
    Emitter<TimestampConverterState> emit,
  ) {
    emit(TimestampConverterState(isMilliseconds: state.isMilliseconds));
  }
}
