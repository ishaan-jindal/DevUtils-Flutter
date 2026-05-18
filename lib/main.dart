import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const DevUtilsApp());
}

class DevUtilsApp extends StatelessWidget {
  const DevUtilsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              return MaterialApp.router(
                title: 'DevUtils',
                debugShowCheckedModeBanner: false,
                themeMode: themeMode,
                theme: AppTheme.light(dynamicScheme: lightDynamic),
                darkTheme: AppTheme.dark(dynamicScheme: darkDynamic),
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
