import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../di/injection.dart';
import '../bloc/jwt_decoder_bloc.dart';
import '../widgets/jwt_input_area.dart';
import '../widgets/jwt_output_card.dart';

class JwtDecoderPage extends StatefulWidget {
  const JwtDecoderPage({super.key});

  @override
  State<JwtDecoderPage> createState() => _JwtDecoderPageState();
}

class _JwtDecoderPageState extends State<JwtDecoderPage> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<JwtDecoderBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.jwtDecoder.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.security_rounded,
                  size: 18,
                  color: AppColors.jwtDecoder,
                ),
              ),
              const SizedBox(width: 10),
              const Text('JWT Decoder'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JwtInputArea(controller: _inputController),

              const SizedBox(height: AppConstants.spacingLg),

              BlocBuilder<JwtDecoderBloc, JwtDecoderState>(
                builder: (context, state) {
                  if (state.headerFormatted == null ||
                      state.payloadFormatted == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.spacingXxl),
                        child: Text(
                          'Enter a valid JWT to view decoded payload',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      JwtOutputCard(
                        title: 'HEADER (Algorithm & Token Type)',
                        content: state.headerFormatted!,
                        headerColor: Colors.redAccent,
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      JwtOutputCard(
                        title: 'PAYLOAD (Data)',
                        content: state.payloadFormatted!,
                        headerColor: Colors.purpleAccent,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
