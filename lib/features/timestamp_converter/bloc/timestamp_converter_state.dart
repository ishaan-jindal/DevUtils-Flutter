part of 'timestamp_converter_bloc.dart';

/// State for the Timestamp Converter BLoC.
class TimestampConverterState extends Equatable {
  const TimestampConverterState({
    this.input = '',
    this.dateTime,
    this.isMilliseconds = true,
    this.error,
  });

  final String input;
  final DateTime? dateTime;
  final bool isMilliseconds;
  final String? error;

  TimestampConverterState copyWith({
    String? input,
    DateTime? dateTime,
    bool? isMilliseconds,
    String? error,
    bool clearError = false,
    bool clearDateTime = false,
  }) {
    return TimestampConverterState(
      input: input ?? this.input,
      dateTime: clearDateTime ? null : (dateTime ?? this.dateTime),
      isMilliseconds: isMilliseconds ?? this.isMilliseconds,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [input, dateTime, isMilliseconds, error];
}
