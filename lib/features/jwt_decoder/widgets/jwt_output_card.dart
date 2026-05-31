import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/snackbar_utils.dart';

class JwtOutputCard extends StatelessWidget {
  final String title;
  final String content;
  final Color headerColor;

  const JwtOutputCard({
    super.key,
    required this.title,
    required this.content,
    required this.headerColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: headerColor.withValues(alpha: 0.15),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: headerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Copy $title',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: content));
                    SnackbarUtils.showSuccess(
                      context,
                      '$title copied to clipboard',
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            child: SelectableText(
              content,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
