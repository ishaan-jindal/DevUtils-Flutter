part of 'api_tester_bloc.dart';

class ApiTesterState extends Equatable {
  const ApiTesterState({
    this.method = 'GET',
    this.url = '',
    this.headersInput = '',
    this.bodyInput = '',
    this.isLoading = false,
    this.statusCode,
    this.timeDuration,
    this.responseBody,
    this.responseHeaders,
    this.error,
  });

  final String method;
  final String url;
  final String headersInput;
  final String bodyInput;

  final bool isLoading;
  final int? statusCode;
  final Duration? timeDuration;
  final String? responseBody;
  final Map<String, String>? responseHeaders;
  final String? error;

  ApiTesterState copyWith({
    String? method,
    String? url,
    String? headersInput,
    String? bodyInput,
    bool? isLoading,
    int? statusCode,
    Duration? timeDuration,
    String? responseBody,
    Map<String, String>? responseHeaders,
    String? error,
    bool clearResponse = false,
    bool clearError = false,
  }) {
    return ApiTesterState(
      method: method ?? this.method,
      url: url ?? this.url,
      headersInput: headersInput ?? this.headersInput,
      bodyInput: bodyInput ?? this.bodyInput,
      isLoading: isLoading ?? this.isLoading,
      statusCode: clearResponse ? null : (statusCode ?? this.statusCode),
      timeDuration: clearResponse ? null : (timeDuration ?? this.timeDuration),
      responseBody: clearResponse ? null : (responseBody ?? this.responseBody),
      responseHeaders: clearResponse
          ? null
          : (responseHeaders ?? this.responseHeaders),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    method,
    url,
    headersInput,
    bodyInput,
    isLoading,
    statusCode,
    timeDuration,
    responseBody,
    responseHeaders,
    error,
  ];
}
