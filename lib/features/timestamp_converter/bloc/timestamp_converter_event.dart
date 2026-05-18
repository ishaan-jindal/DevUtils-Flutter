part of 'timestamp_converter_bloc.dart';

/// Events for the Timestamp Converter BLoC.
abstract class TimestampConverterEvent extends Equatable {
  const TimestampConverterEvent();

  @override
  List<Object?> get props => [];
}

class TimestampInputChanged extends TimestampConverterEvent {
  const TimestampInputChanged(this.input);
  final String input;

  @override
  List<Object?> get props => [input];
}

class TimestampModeChanged extends TimestampConverterEvent {
  const TimestampModeChanged(this.isMilliseconds);
  final bool isMilliseconds;

  @override
  List<Object?> get props => [isMilliseconds];
}

class TimestampNowRequested extends TimestampConverterEvent {
  const TimestampNowRequested();
}

class TimestampClearRequested extends TimestampConverterEvent {
  const TimestampClearRequested();
}
