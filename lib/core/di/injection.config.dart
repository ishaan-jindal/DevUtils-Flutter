// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dev_utils/features/json_formatter/bloc/json_formatter_bloc.dart'
    as _i113;
import 'package:dev_utils/features/json_formatter/services/json_formatter_service.dart'
    as _i181;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i181.JsonFormatterService>(
      () => _i181.JsonFormatterService(),
    );
    gh.factory<_i113.JsonFormatterBloc>(
      () => _i113.JsonFormatterBloc(gh<_i181.JsonFormatterService>()),
    );
    return this;
  }
}
