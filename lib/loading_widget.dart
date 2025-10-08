// In lib/loading_widget.dart
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class RavalLoadingIndicator extends StatelessWidget {
  const RavalLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedTextKit(
        repeatForever: true, // تكرار الأنيميشن للأبد
        animatedTexts: [
          // الأنيميشن الأول: يكتب الكلمة
          FadeAnimatedText(
            'R',
            duration: const Duration(milliseconds: 300),
            textStyle: _textStyle(context),
          ),
           FadeAnimatedText(
            'RA',
            duration: const Duration(milliseconds: 300),
            textStyle: _textStyle(context),
          ),
          FadeAnimatedText(
            'RAV',
            duration: const Duration(milliseconds: 300),
            textStyle: _textStyle(context),
          ),
          FadeAnimatedText(
            'RAVA',
            duration: const Duration(milliseconds: 300),
            textStyle: _textStyle(context),
          ),
          FadeAnimatedText(
            'RAVAL',
            duration: const Duration(milliseconds: 1000), // يثبت على الكلمة لثانية
            textStyle: _textStyle(context),
          ),
          // الأنيميشن الثاني: يخفي الكلمة
          FadeAnimatedText(
            'RAVA',
            duration: const Duration(milliseconds: 300),
            textStyle: _textStyle(context),
          ),
           FadeAnimatedText(
            'RAV',
            duration: const Duration(milliseconds: 300),
            textStyle: _textStyle(context),
          ),
           FadeAnimatedText(
            'RA',
            duration: const Duration(milliseconds: 300),
            textStyle: _textStyle(context),
          ),
          FadeAnimatedText(
            'R',
            duration: const Duration(milliseconds: 300),
            textStyle: _textStyle(context),
          ),
           FadeAnimatedText(
            '', // يخفي كل الحروف
            duration: const Duration(milliseconds: 500),
            textStyle: _textStyle(context),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle(BuildContext context) {
    return TextStyle(
      fontSize: 32.0,
      fontFamily: 'Exo2',
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor,
    );
  }
}