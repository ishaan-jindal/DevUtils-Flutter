part of 'api_tester_bloc.dart';

abstract class ApiTesterEvent extends Equatable {
  const ApiTesterEvent();

  @override
  List<Object?> get props => [];
}

class ApiMethodChanged extends ApiTesterEvent {
  const ApiMethodChanged(this.method);
  final String method;
  @override
  List<Object?> get props => [method];
}

class ApiUrlChanged extends ApiTesterEvent {
  const ApiUrlChanged(this.url);
  final String url;
  @override
  List<Object?> get props => [url];
}

class ApiHeadersChanged extends ApiTesterEvent {
  const ApiHeadersChanged(this.headers);
  final String headers;
  @override
  List<Object?> get props => [headers];
}

class ApiBodyChanged extends ApiTesterEvent {
  const ApiBodyChanged(this.body);
  final String body;
  @override
  List<Object?> get props => [body];
}

class ApiSendRequested extends ApiTesterEvent {
  const ApiSendRequested();
}

class ApiClearRequested extends ApiTesterEvent {
  const ApiClearRequested();
}
