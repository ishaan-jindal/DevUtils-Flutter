import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/pages/home_page.dart';
import '../../features/json_formatter/pages/json_formatter_page.dart';
import '../../features/timestamp_converter/pages/timestamp_converter_page.dart';

/// App-wide router configuration
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/json-formatter',
        name: 'json_formatter',
        builder: (context, state) => const JsonFormatterPage(),
      ),
      GoRoute(
        path: '/timestamp-converter',
        name: 'timestamp_converter',
        builder: (context, state) => const TimestampConverterPage(),
      ),
      // ── Future tool routes ──
      // GoRoute(path: '/jwt-decoder', ...),
      // GoRoute(path: '/regex-tester', ...),
      // GoRoute(path: '/base64-tools', ...),
      // GoRoute(path: '/url-encoder', ...),
      // GoRoute(path: '/hash-generator', ...),
      // GoRoute(path: '/color-tools', ...),
    ],
  );
}
