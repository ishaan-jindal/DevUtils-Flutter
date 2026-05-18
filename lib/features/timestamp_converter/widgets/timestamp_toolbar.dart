import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/timestamp_converter_bloc.dart';

class TimestampToolbar extends StatelessWidget {
  final TextEditingController inputController;

  const TimestampToolbar({super.key, required this.inputController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<TimestampConverterBloc, TimestampConverterState>(
      buildWhen: (previous, current) =>
          previous.isMilliseconds != current.isMilliseconds,
      builder: (context, state) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ToggleButtons(
              isSelected: [!state.isMilliseconds, state.isMilliseconds],
              onPressed: (index) {
                context.read<TimestampConverterBloc>().add(
                  TimestampModeChanged(index == 1),
                );
              },
              borderRadius: BorderRadius.circular(8),
              constraints: const BoxConstraints(minHeight: 36, minWidth: 80),
              children: const [Text('Seconds'), Text('Millis')],
            ),
            FilledButton.icon(
              onPressed: () {
                context.read<TimestampConverterBloc>().add(
                  const TimestampNowRequested(),
                );
              },
              icon: const Icon(Icons.schedule_rounded, size: 16),
              label: const Text('Now'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                inputController.clear();
                context.read<TimestampConverterBloc>().add(
                  const TimestampClearRequested(),
                );
              },
              icon: Icon(
                Icons.clear_all_rounded,
                size: 16,
                color: theme.colorScheme.error,
              ),
              label: Text(
                'Clear',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
