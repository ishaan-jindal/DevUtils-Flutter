import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// Toolbar for JSON formatting actions.
class JsonToolbar extends StatelessWidget {
  const JsonToolbar({
    super.key,
    required this.isValid,
    required this.isEmpty,
    required this.indentSize,
    required this.onPrettify,
    required this.onMinify,
    required this.onClear,
    required this.onIndentChanged,
    required this.onSample,
  });

  final bool isValid;
  final bool isEmpty;
  final int indentSize;
  final VoidCallback onPrettify;
  final VoidCallback onMinify;
  final VoidCallback onClear;
  final ValueChanged<int> onIndentChanged;
  final VoidCallback onSample;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // ── Prettify ──
            _ToolbarButton(
              icon: Icons.format_align_left_rounded,
              label: 'Prettify',
              onPressed: isValid ? onPrettify : null,
              isPrimary: true,
            ),
            const SizedBox(width: 8),

            // ── Minify ──
            _ToolbarButton(
              icon: Icons.compress_rounded,
              label: 'Minify',
              onPressed: isValid ? onMinify : null,
            ),
            const SizedBox(width: 8),

            // ── Indent selector ──
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: indentSize,
                  isDense: true,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  items: [2, 4, 8].map((size) {
                    return DropdownMenuItem(
                      value: size,
                      child: Text('$size spaces'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) onIndentChanged(value);
                  },
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Divider
            Container(
              width: 1,
              height: 20,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),

            const SizedBox(width: 8),

            // ── Sample ──
            _ToolbarButton(
              icon: Icons.science_rounded,
              label: 'Sample',
              onPressed: onSample,
            ),
            const SizedBox(width: 8),

            // ── Clear ──
            _ToolbarButton(
              icon: Icons.clear_all_rounded,
              label: 'Clear',
              onPressed: isEmpty ? null : onClear,
              isDanger: true,
            ),

            const SizedBox(width: 8),

            // ── Validation indicator ──
            if (!isEmpty)
              AnimatedContainer(
                duration: AppConstants.animFast,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isValid
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isValid
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      size: 14,
                      color: isValid ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isValid ? 'Valid' : 'Invalid',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isValid ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDanger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isPrimary) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          minimumSize: const Size(0, 36),
          textStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 16,
        color: isDanger ? theme.colorScheme.error : null,
      ),
      label: Text(
        label,
        style: TextStyle(color: isDanger ? theme.colorScheme.error : null),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        minimumSize: const Size(0, 36),
        side: BorderSide(
          color: isDanger
              ? theme.colorScheme.error.withValues(alpha: 0.5)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
