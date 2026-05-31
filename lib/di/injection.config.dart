// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dev_utils/features/api_tester/bloc/api_tester_bloc.dart'
    as _i899;
import 'package:dev_utils/features/api_tester/services/api_tester_service.dart'
    as _i517;
import 'package:dev_utils/features/json_formatter/bloc/json_formatter_bloc.dart'
    as _i113;
import 'package:dev_utils/features/json_formatter/services/json_formatter_service.dart'
    as _i181;
import 'package:dev_utils/features/jwt_decoder/bloc/jwt_decoder_bloc.dart'
    as _i635;
import 'package:dev_utils/features/jwt_decoder/services/jwt_decoder_service.dart'
    as _i998;
import 'package:dev_utils/features/timestamp_converter/bloc/timestamp_converter_bloc.dart'
    as _i776;
import 'package:dev_utils/features/timestamp_converter/services/timestamp_converter_service.dart'
    as _i404;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i776.TimestampConverterBloc>(
      () => _i776.TimestampConverterBloc(),
    );
    gh.lazySingleton<_i517.ApiTesterService>(() => _i517.ApiTesterService());
    gh.lazySingleton<_i181.JsonFormatterService>(
      () => _i181.JsonFormatterService(),
    );
    gh.lazySingleton<_i998.JwtDecoderService>(() => _i998.JwtDecoderService());
    gh.lazySingleton<_i404.TimestampConverterService>(
      () => _i404.TimestampConverterService(),
    );
    gh.factory<_i899.ApiTesterBloc>(
      () => _i899.ApiTesterBloc(gh<_i517.ApiTesterService>()),
    );
    gh.factory<_i113.JsonFormatterBloc>(
      () => _i113.JsonFormatterBloc(gh<_i181.JsonFormatterService>()),
    );
    gh.factory<_i635.JwtDecoderBloc>(
      () => _i635.JwtDecoderBloc(gh<_i998.JwtDecoderService>()),
    );
    return this;
  }
}
