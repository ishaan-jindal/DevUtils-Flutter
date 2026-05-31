import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/jwt_decoder_bloc.dart';

class JwtInputArea extends StatelessWidget {
  final TextEditingController controller;

  const JwtInputArea({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JwtDecoderBloc, JwtDecoderState>(
      builder: (context, state) {
        return TextField(
          controller: controller,
          maxLines: 8,
          minLines: 4,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          decoration: InputDecoration(
            labelText: 'Encoded JWT String',
            hintText: 'Paste your JWT here (ey...).',
            errorText: state.error,
            alignLabelWithHint: true,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller.clear();
                context.read<JwtDecoderBloc>().add(const JwtClearRequested());
              },
            ),
          ),
          onChanged: (val) {
            context.read<JwtDecoderBloc>().add(JwtInputChanged(val));
          },
        );
      },
    );
  }
}
