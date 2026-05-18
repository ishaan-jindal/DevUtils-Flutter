import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';

/// Syntax-highlighted JSON output display.
class JsonOutputArea extends StatelessWidget {
  const JsonOutputArea({
    super.key,
    required this.output,
    required this.isValid,
    this.errorMessage,
    this.errorLine,
    this.errorColumn,
  });

  final String output;
  final bool isValid;
  final String? errorMessage;
  final int? errorLine;
  final int? errorColumn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingSm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.code_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Output',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (output.isNotEmpty)
                _ActionChip(
                  icon: Icons.copy_rounded,
                  label: 'Copy',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: output));
                    SnackbarUtils.showSuccess(context, 'Copied to clipboard!');
                  },
                ),
            ],
          ),
        ),

        // ── Output / Error ──
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    )
                  : theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: errorMessage != null && output.isEmpty
                    ? theme.colorScheme.error.withValues(alpha: 0.4)
                    : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              child: _buildContent(context, theme, isDark),
            ),
          ),
        ),

        // ── Error bar ──
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: AppConstants.spacingSm,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorLine != null
                          ? 'Line $errorLine, Col $errorColumn: $errorMessage'
                          : errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          const SizedBox(height: AppConstants.spacingSm),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, bool isDark) {
    if (output.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.data_object_rounded,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 12),
            Text(
              'Formatted output will appear here',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: SelectableText.rich(
        _highlightJson(output, isDark),
        style: GoogleFonts.jetBrainsMono(fontSize: 13, height: 1.6),
      ),
    );
  }

  /// Syntax highlight JSON text.
  TextSpan _highlightJson(String json, bool isDark) {
    final spans = <TextSpan>[];
    int i = 0;

    Color keyColor = isDark ? AppColors.syntaxKey : AppColors.syntaxKeyLight;
    Color stringColor = isDark
        ? AppColors.syntaxString
        : AppColors.syntaxStringLight;
    Color numberColor = isDark
        ? AppColors.syntaxNumber
        : AppColors.syntaxNumberLight;
    Color boolColor = isDark
        ? AppColors.syntaxBoolean
        : AppColors.syntaxBooleanLight;
    Color nullColor = isDark ? AppColors.syntaxNull : AppColors.syntaxNullLight;
    Color bracketColor = isDark
        ? AppColors.syntaxBracket
        : AppColors.syntaxBracketLight;

    while (i < json.length) {
      final c = json[i];

      // Brackets and structural chars
      if (c == '{' ||
          c == '}' ||
          c == '[' ||
          c == ']' ||
          c == ',' ||
          c == ':') {
        spans.add(
          TextSpan(
            text: c,
            style: TextStyle(color: bracketColor),
          ),
        );
        i++;
        continue;
      }

      // Strings
      if (c == '"') {
        final start = i;
        i++; // skip opening quote
        while (i < json.length) {
          if (json[i] == '\\') {
            i += 2; // skip escaped char
          } else if (json[i] == '"') {
            i++; // skip closing quote
            break;
          } else {
            i++;
          }
        }
        final str = json.substring(start, i);

        // Check if this is a key (followed by colon)
        int j = i;
        while (j < json.length && json[j] == ' ' ||
            (j < json.length && json[j] == '\n') ||
            (j < json.length && json[j] == '\r') ||
            (j < json.length && json[j] == '\t')) {
          j++;
        }
        final isKey = j < json.length && json[j] == ':';

        spans.add(
          TextSpan(
            text: str,
            style: TextStyle(color: isKey ? keyColor : stringColor),
          ),
        );
        continue;
      }

      // Numbers
      if (c == '-' || (c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57)) {
        final start = i;
        if (c == '-') i++;
        while (i < json.length &&
            ((json[i].codeUnitAt(0) >= 48 && json[i].codeUnitAt(0) <= 57) ||
                json[i] == '.' ||
                json[i] == 'e' ||
                json[i] == 'E' ||
                json[i] == '+' ||
                json[i] == '-')) {
          if ((json[i] == '-' || json[i] == '+') &&
              i > start + 1 &&
              json[i - 1] != 'e' &&
              json[i - 1] != 'E') {
            break;
          }
          i++;
        }
        spans.add(
          TextSpan(
            text: json.substring(start, i),
            style: TextStyle(color: numberColor),
          ),
        );
        continue;
      }

      // Booleans
      if (json.startsWith('true', i)) {
        spans.add(
          TextSpan(
            text: 'true',
            style: TextStyle(color: boolColor),
          ),
        );
        i += 4;
        continue;
      }
      if (json.startsWith('false', i)) {
        spans.add(
          TextSpan(
            text: 'false',
            style: TextStyle(color: boolColor),
          ),
        );
        i += 5;
        continue;
      }

      // Null
      if (json.startsWith('null', i)) {
        spans.add(
          TextSpan(
            text: 'null',
            style: TextStyle(color: nullColor, fontStyle: FontStyle.italic),
          ),
        );
        i += 4;
        continue;
      }

      // Whitespace / other
      spans.add(TextSpan(text: c));
      i++;
    }

    return TextSpan(children: spans);
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: theme.colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
