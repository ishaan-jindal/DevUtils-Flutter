import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../services/api_tester_service.dart';

part 'api_tester_event.dart';
part 'api_tester_state.dart';

@injectable
class ApiTesterBloc extends Bloc<ApiTesterEvent, ApiTesterState> {
  final ApiTesterService _service;

  ApiTesterBloc(this._service) : super(const ApiTesterState()) {
    on<ApiMethodChanged>(
      (event, emit) => emit(state.copyWith(method: event.method)),
    );
    on<ApiUrlChanged>(
      (event, emit) => emit(state.copyWith(url: event.url, clearError: true)),
    );
    on<ApiHeadersChanged>(
      (event, emit) => emit(state.copyWith(headersInput: event.headers)),
    );
    on<ApiBodyChanged>(
      (event, emit) => emit(state.copyWith(bodyInput: event.body)),
    );
    on<ApiClearRequested>((event, emit) => emit(const ApiTesterState()));
    on<ApiSendRequested>(_onSendRequested);
  }

  Future<void> _onSendRequested(
    ApiSendRequested event,
    Emitter<ApiTesterState> emit,
  ) async {
    if (state.url.trim().isEmpty) {
      emit(state.copyWith(error: 'URL cannot be empty', clearResponse: true));
      return;
    }

    emit(
      state.copyWith(isLoading: true, clearError: true, clearResponse: true),
    );

    try {
      final url = state.url.startsWith('http')
          ? state.url
          : 'https://${state.url}';

      final (response, duration) = await _service.sendRequest(
        method: state.method,
        url: url,
        headersJson: state.headersInput,
        body: state.bodyInput,
      );

      emit(
        state.copyWith(
          isLoading: false,
          statusCode: response.statusCode,
          timeDuration: duration,
          responseHeaders: response.headers,
          responseBody: _service.formatResponseBody(response.body),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Request failed: ${e.toString()}',
        ),
      );
    }
  }
}
