
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingManager {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Blurred background
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Lottie animation
          Center(
            // Get animation from https://lottiefiles.com/animations/loading-lottie-animation-zT Διαφ
            child: Lottie.asset(
              'assets/images/loading_animation.json',
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
