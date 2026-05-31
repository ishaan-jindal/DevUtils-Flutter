import 'package:dev_utils/features/jwt_decoder/services/jwt_decoder_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'jwt_decoder_event.dart';
part 'jwt_decoder_state.dart';

@injectable
class JwtDecoderBloc extends Bloc<JwtDecoderEvent, JwtDecoderState> {
  final JwtDecoderService _service;

  JwtDecoderBloc(this._service) : super(const JwtDecoderState()) {
    on<JwtInputChanged>(_onInputChanged);
    on<JwtClearRequested>(_onClearRequested);
  }

  void _onInputChanged(JwtInputChanged event, Emitter<JwtDecoderState> emit) {
    final input = event.input.trim();

    if (input.isEmpty) {
      emit(
        state.copyWith(
          input: '',
          clearOutputs: true,
          clearError: true,
          isFormatValid: false,
        ),
      );
    }

    final parts = input.split('.');

    if (parts.length != 3) {
      emit(
        state.copyWith(
          input: input,
          isFormatValid: false,
          error:
              'Invalid JWT Format. A JWT must have 3 parts seperated by dots.',
          clearOutputs: true,
        ),
      );
      return;
    }

    final headerMap = _service.decodePart(parts[0]);
    final payloadMap = _service.decodePart(parts[1]);

    if (headerMap == null || payloadMap == null) {
      emit(
        state.copyWith(
          input: input,
          isFormatValid: true,
          error: 'Failed to decode Base64Url payload.',
          clearOutputs: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        input: input,
        isFormatValid: true,
        clearError: true,
        headerFormatted: _service.formatJson(headerMap),
        payloadFormatted: _service.formatJson(payloadMap),
      ),
    );
  }

  void _onClearRequested(
    JwtClearRequested event,
    Emitter<JwtDecoderState> emit,
  ) {
    emit(const JwtDecoderState());
  }
}
