import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RavalLoadingIndicator extends StatelessWidget {
  const RavalLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/images/loading_animation.json',
        width: 200,
        height: 200,
      ),
    );
  }
}