import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../di/injection.dart';
import '../bloc/api_tester_bloc.dart';
import '../widgets/api_request_bar.dart';
import '../widgets/api_response_card.dart';

class ApiTesterPage extends StatefulWidget {
  const ApiTesterPage({super.key});

  @override
  State<ApiTesterPage> createState() => _ApiTesterPageState();
}

class _ApiTesterPageState extends State<ApiTesterPage> {
  final _urlController = TextEditingController();
  final _headersController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _headersController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ApiTesterBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.apiTester.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.api_rounded,
                  size: 18,
                  color: AppColors.apiTester,
                ),
              ),
              const SizedBox(width: 10),
              const Text('API Tester'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: BlocConsumer<ApiTesterBloc, ApiTesterState>(
            listenWhen: (previous, current) =>
                previous.error != current.error && current.error != null,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            builder: (context, state) {
              final theme = Theme.of(context);
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact =
                          constraints.maxWidth < AppConstants.breakpointTablet;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ApiRequestBar(urlController: _urlController),
                          const SizedBox(height: AppConstants.spacingLg),
                          Container(
                            padding: const EdgeInsets.all(
                              AppConstants.spacingMd,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusLg,
                              ),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.35),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.tune_rounded,
                                      size: 18,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Request Configuration',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppConstants.spacingMd),
                                isCompact
                                    ? Column(
                                        children: [
                                          _RequestFieldCard(
                                            title: 'Headers (JSON)',
                                            icon: Icons.dns_rounded,
                                            child: TextField(
                                              controller: _headersController,
                                              maxLines: 5,
                                              minLines: 3,
                                              style: const TextStyle(
                                                fontFamily: 'monospace',
                                                fontSize: 13,
                                              ),
                                              decoration: const InputDecoration(
                                                hintText:
                                                    '{\n  "Authorization": "Bearer ..."\n}',
                                                alignLabelWithHint: true,
                                              ),
                                              onChanged: (val) => context
                                                  .read<ApiTesterBloc>()
                                                  .add(ApiHeadersChanged(val)),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: AppConstants.spacingMd,
                                          ),
                                          _RequestFieldCard(
                                            title: 'Request Body',
                                            icon: Icons.description_rounded,
                                            child: TextField(
                                              controller: _bodyController,
                                              maxLines: 5,
                                              minLines: 3,
                                              enabled: [
                                                'POST',
                                                'PUT',
                                                'PATCH',
                                              ].contains(state.method),
                                              style: const TextStyle(
                                                fontFamily: 'monospace',
                                                fontSize: 13,
                                              ),
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Enter payload here...',
                                                alignLabelWithHint: true,
                                                filled: ![
                                                  'POST',
                                                  'PUT',
                                                  'PATCH',
                                                ].contains(state.method),
                                              ),
                                              onChanged: (val) => context
                                                  .read<ApiTesterBloc>()
                                                  .add(ApiBodyChanged(val)),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: _RequestFieldCard(
                                              title: 'Headers (JSON)',
                                              icon: Icons.dns_rounded,
                                              child: TextField(
                                                controller: _headersController,
                                                maxLines: 6,
                                                minLines: 4,
                                                style: const TextStyle(
                                                  fontFamily: 'monospace',
                                                  fontSize: 13,
                                                ),
                                                decoration: const InputDecoration(
                                                  hintText:
                                                      '{\n  "Authorization": "Bearer ..."\n}',
                                                  alignLabelWithHint: true,
                                                ),
                                                onChanged: (val) => context
                                                    .read<ApiTesterBloc>()
                                                    .add(
                                                      ApiHeadersChanged(val),
                                                    ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: AppConstants.spacingMd,
                                          ),
                                          Expanded(
                                            child: _RequestFieldCard(
                                              title: 'Request Body',
                                              icon: Icons.description_rounded,
                                              child: TextField(
                                                controller: _bodyController,
                                                maxLines: 6,
                                                minLines: 4,
                                                enabled: [
                                                  'POST',
                                                  'PUT',
                                                  'PATCH',
                                                ].contains(state.method),
                                                style: const TextStyle(
                                                  fontFamily: 'monospace',
                                                  fontSize: 13,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter payload here...',
                                                  alignLabelWithHint: true,
                                                  filled: ![
                                                    'POST',
                                                    'PUT',
                                                    'PATCH',
                                                  ].contains(state.method),
                                                ),
                                                onChanged: (val) => context
                                                    .read<ApiTesterBloc>()
                                                    .add(ApiBodyChanged(val)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingXxl),
                          Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Response',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.spacingSm),
                          ApiResponseCard(state: state),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RequestFieldCard extends StatelessWidget {
  const _RequestFieldCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          child,
        ],
      ),
    );
  }
}
