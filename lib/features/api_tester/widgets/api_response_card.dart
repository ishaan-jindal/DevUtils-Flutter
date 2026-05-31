import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../bloc/api_tester_bloc.dart';

class ApiResponseCard extends StatelessWidget {
  final ApiTesterState state;

  const ApiResponseCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color statusColor = theme.colorScheme.outline;
    if (state.statusCode != null) {
      if (state.statusCode! >= 200 && state.statusCode! < 300) {
        statusColor = Colors.green;
      } else if (state.statusCode! >= 400) {
        statusColor = Colors.redAccent;
      } else if (state.statusCode! >= 300) {
        statusColor = Colors.orange;
      }
    }

    final responseHeaderCount = state.responseHeaders?.length ?? 0;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.35 : 0.55,
            ),
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact =
                    constraints.maxWidth < AppConstants.breakpointMobile;

                final chips = [
                  _InfoChip(
                    label: 'Status',
                    value: '${state.statusCode ?? '-'}',
                    valueColor: statusColor,
                  ),
                  _InfoChip(
                    label: 'Time',
                    value: '${state.timeDuration?.inMilliseconds ?? 0} ms',
                    icon: Icons.timer_outlined,
                  ),
                  _InfoChip(
                    label: 'Headers',
                    value: '$responseHeaderCount',
                    icon: Icons.tune_rounded,
                  ),
                ];

                return compact
                    ? Wrap(
                        spacing: AppConstants.spacingSm,
                        runSpacing: AppConstants.spacingSm,
                        children: chips,
                      )
                    : Row(
                        children: [
                          Expanded(child: chips[0]),
                          const SizedBox(width: AppConstants.spacingSm),
                          Expanded(child: chips[1]),
                          const SizedBox(width: AppConstants.spacingSm),
                          Expanded(child: chips[2]),
                        ],
                      );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            constraints: const BoxConstraints(minHeight: 150),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: theme.brightness == Brightness.dark ? 0.22 : 0.35,
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                child: SelectionArea(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      state.responseBody?.isEmpty == true
                          ? 'No Content'
                          : (state.responseBody ?? 'Awaiting Request...'),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
          ],
          Text(
            '$label: ',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.labelMedium?.copyWith(
              color: valueColor ?? theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
