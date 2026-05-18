import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../di/injection.dart';
import '../bloc/json_formatter_bloc.dart';
import '../widgets/json_input_area.dart';
import '../widgets/json_output_area.dart';
import '../widgets/json_toolbar.dart';

/// Full-screen JSON Formatter tool page.
class JsonFormatterPage extends StatefulWidget {
  const JsonFormatterPage({super.key});

  @override
  State<JsonFormatterPage> createState() => _JsonFormatterPageState();
}

class _JsonFormatterPageState extends State<JsonFormatterPage> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<JsonFormatterBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: .min,
            children: [
              Container(
                padding: const .all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF26A69A).withValues(alpha: 0.12),
                  borderRadius: .circular(8),
                ),
                child: const Icon(
                  Icons.data_object_rounded,
                  size: 18,
                  color: Color(0xFF26A69A),
                ),
              ),
              const SizedBox(width: 10),
              const Text('JSON Formatter'),
            ],
          ),
        ),
        body: BlocListener<JsonFormatterBloc, JsonFormatterState>(
          listener: (context, state) {
            if (_inputController.text != state.input) {
              _inputController.value = TextEditingValue(
                text: state.input,
                selection: .collapsed(offset: state.input.length),
              );
            }
          },
          child: BlocBuilder<JsonFormatterBloc, JsonFormatterState>(
            builder: (context, state) {
              return Column(
                children: [
                  // ── Toolbar ──
                  JsonToolbar(
                    isValid: state.isValid,
                    isEmpty: state.isEmpty,
                    indentSize: state.indentSize,
                    onPrettify: () => context.read<JsonFormatterBloc>().add(
                      const JsonPrettifyRequested(),
                    ),
                    onMinify: () => context.read<JsonFormatterBloc>().add(
                      const JsonMinifyRequested(),
                    ),
                    onClear: () {
                      _inputController.clear();
                      context.read<JsonFormatterBloc>().add(
                        const JsonClearRequested(),
                      );
                    },
                    onIndentChanged: (indent) => context
                        .read<JsonFormatterBloc>()
                        .add(JsonIndentChanged(indent)),
                    onSample: () {
                      context.read<JsonFormatterBloc>().add(
                        const JsonSampleRequested(),
                      );
                    },
                  ),

                  // ── Input & Output panels ──
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide =
                            constraints.maxWidth >
                            AppConstants.breakpointMobile;

                        if (isWide) {
                          // ── Side by side ──
                          return Row(
                            children: [
                              Expanded(
                                child: JsonInputArea(
                                  controller: _inputController,
                                  onChanged: (text) => context
                                      .read<JsonFormatterBloc>()
                                      .add(JsonInputChanged(text)),
                                  errorLine: state.errorLine,
                                ),
                              ),
                              Container(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant
                                    .withValues(alpha: 0.3),
                              ),
                              Expanded(
                                child: JsonOutputArea(
                                  output: state.output,
                                  isValid: state.isValid,
                                  errorMessage: state.errorMessage,
                                  errorLine: state.errorLine,
                                  errorColumn: state.errorColumn,
                                ),
                              ),
                            ],
                          );
                        }

                        // ── Stacked ──
                        return Column(
                          children: [
                            Expanded(
                              child: JsonInputArea(
                                controller: _inputController,
                                onChanged: (text) => context
                                    .read<JsonFormatterBloc>()
                                    .add(JsonInputChanged(text)),
                                errorLine: state.errorLine,
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant
                                  .withValues(alpha: 0.3),
                            ),
                            Expanded(
                              child: JsonOutputArea(
                                output: state.output,
                                isValid: state.isValid,
                                errorMessage: state.errorMessage,
                                errorLine: state.errorLine,
                                errorColumn: state.errorColumn,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
