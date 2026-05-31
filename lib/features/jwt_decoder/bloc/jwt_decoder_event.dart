part of 'jwt_decoder_bloc.dart';

abstract class JwtDecoderEvent extends Equatable {
  const JwtDecoderEvent();

  @override
  List<Object?> get props => [];
}

class JwtInputChanged extends JwtDecoderEvent {
  const JwtInputChanged(this.input);
  final String input;

  @override
  List<Object?> get props => [input];
}

class JwtClearRequested extends JwtDecoderEvent {
  const JwtClearRequested();
}
