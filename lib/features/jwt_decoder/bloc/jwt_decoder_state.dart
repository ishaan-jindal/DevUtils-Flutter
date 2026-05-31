part of 'jwt_decoder_bloc.dart';

class JwtDecoderState extends Equatable {
  const JwtDecoderState({
    this.input = '',
    this.headerFormatted,
    this.payloadFormatted,
    this.isFormatValid = false,
    this.error,
  });

  final String input;
  final String? headerFormatted;
  final String? payloadFormatted;
  final bool isFormatValid;
  final String? error;

  JwtDecoderState copyWith({
    String? input,
    String? headerFormatted,
    String? payloadFormatted,
    bool? isFormatValid,
    String? error,
    bool clearOutputs = false,
    bool clearError = false,
  }) {
    return JwtDecoderState(
      input: input ?? this.input,
      headerFormatted: clearOutputs
          ? null
          : (headerFormatted ?? this.headerFormatted),
      payloadFormatted: clearOutputs
          ? null
          : (payloadFormatted ?? this.payloadFormatted),
      isFormatValid: isFormatValid ?? this.isFormatValid,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    input,
    headerFormatted,
    payloadFormatted,
    isFormatValid,
    error,
  ];
}
