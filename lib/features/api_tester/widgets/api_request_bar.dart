import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../bloc/api_tester_bloc.dart';

class ApiRequestBar extends StatelessWidget {
  final TextEditingController urlController;

  const ApiRequestBar({super.key, required this.urlController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiTesterBloc, ApiTesterState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        Widget methodPicker() {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.35 : 0.5,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state.method,
                isExpanded: true,
                items: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']
                    .map(
                      (m) => DropdownMenuItem(
                        value: m,
                        child: Text(
                          m,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    context.read<ApiTesterBloc>().add(ApiMethodChanged(val));
                  }
                },
              ),
            ),
          );
        }

        Widget urlField() {
          return TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: 'https://api.example.com/v1/users',
            ),
            onChanged: (val) =>
                context.read<ApiTesterBloc>().add(ApiUrlChanged(val)),
            onSubmitted: (_) =>
                context.read<ApiTesterBloc>().add(const ApiSendRequested()),
          );
        }

        Widget sendButton({required bool compact}) {
          return SizedBox(
            width: compact ? double.infinity : null,
            child: FilledButton(
              onPressed: state.isLoading
                  ? null
                  : () => context.read<ApiTesterBloc>().add(
                      const ApiSendRequested(),
                    ),
              child: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Send'),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final compact =
                constraints.maxWidth < AppConstants.breakpointTablet;

            return Container(
              padding: const EdgeInsets.all(AppConstants.spacingSm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.35,
                  ),
                ),
              ),
              child: compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        methodPicker(),
                        const SizedBox(height: AppConstants.spacingSm),
                        urlField(),
                        const SizedBox(height: AppConstants.spacingSm),
                        sendButton(compact: true),
                      ],
                    )
                  : Row(
                      children: [
                        SizedBox(width: 124, child: methodPicker()),
                        const SizedBox(width: AppConstants.spacingSm),
                        Expanded(child: urlField()),
                        const SizedBox(width: AppConstants.spacingSm),
                        sendButton(compact: false),
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}
