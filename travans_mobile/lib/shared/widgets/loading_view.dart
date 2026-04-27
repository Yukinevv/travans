import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({this.label, super.key});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
        if (label != null) ...[
          const SizedBox(height: 12),
          Text(label!),
        ],
      ],
    );
  }
}
