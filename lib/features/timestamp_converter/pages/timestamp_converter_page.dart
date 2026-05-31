import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../di/injection.dart';
import '../bloc/timestamp_converter_bloc.dart';
import '../services/timestamp_converter_service.dart';
import '../widgets/timestamp_toolbar.dart';
import '../widgets/timestamp_result_card.dart';

class TimestampConverterPage extends StatefulWidget {
  const TimestampConverterPage({super.key});

  @override
  State<TimestampConverterPage> createState() => _TimestampConverterPageState();
}

class _TimestampConverterPageState extends State<TimestampConverterPage> {
  final _inputController = TextEditingController();
  final _service = getIt<TimestampConverterService>();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TimestampConverterBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.timestampConverter.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: AppColors.timestampConverter,
                ),
              ),
              const SizedBox(width: 10),
              const Text('Timestamp Converter'),
            ],
          ),
        ),
        body: BlocConsumer<TimestampConverterBloc, TimestampConverterState>(
          listener: (context, state) {
            // Keep the text controller in sync with the BLoC state when modified externally (e.g., clicking "Now" or "Clear")
            if (_inputController.text != state.input) {
              _inputController.value = TextEditingValue(
                text: state.input,
                selection: TextSelection.collapsed(offset: state.input.length),
              );
            }
          },
          builder: (context, state) {
            final theme = Theme.of(context);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TimestampToolbar(inputController: _inputController),

                      const SizedBox(height: AppConstants.spacingLg),

                      TextField(
                        controller: _inputController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Unix Timestamp',
                          hintText: state.isMilliseconds
                              ? 'e.g. 1672531200000'
                              : 'e.g. 1672531200',
                          errorText: state.error,
                          prefixIcon: const Icon(Icons.tag_rounded),
                        ),
                        onChanged: (val) {
                          context.read<TimestampConverterBloc>().add(
                            TimestampInputChanged(val),
                          );
                        },
                      ),

                      const SizedBox(height: AppConstants.spacingLg),

                      if (state.dateTime != null) ...[
                        Text(
                          'Results',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        TimestampResultCard(
                          label: 'Local Time',
                          value: _service.formatDateTime(state.dateTime!),
                          subtext: state.dateTime!.timeZoneName,
                        ),
                        const SizedBox(height: AppConstants.spacingSm),
                        TimestampResultCard(
                          label: 'UTC Time',
                          value: _service.formatDateTime(
                            state.dateTime!.toUtc(),
                          ),
                          subtext: 'UTC',
                        ),
                        const SizedBox(height: AppConstants.spacingSm),
                        TimestampResultCard(
                          label: 'ISO 8601',
                          value: state.dateTime!.toUtc().toIso8601String(),
                        ),
                        const SizedBox(height: AppConstants.spacingSm),
                        TimestampResultCard(
                          label: 'Relative',
                          value: _service.getRelativeTime(state.dateTime!),
                        ),
                      ] else if (state.input.isEmpty) ...[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              AppConstants.spacingXxl,
                            ),
                            child: Text(
                              'Enter a timestamp or click "Now"',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
