import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10.withOpacity(0.8),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
