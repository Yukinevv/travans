import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 32,
      height: 32,
      child: CircularProgressIndicator(strokeWidth: 3),
    );
  }
}
