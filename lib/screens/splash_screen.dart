import 'dart:async';
import 'package:flutter/material.dart';
import 'package:store/main.dart'; // تأكد من أن هذا هو المسار الصحيح لصفحتك الرئيسية
import 'package:store/screens/home_page.dart';
import 'package:store/theme.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _circlesOpacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _barWidthAnimation; // <-- الأنيميشن الجديد للشريط

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200), // زيادة المدة الإجمالية
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _circlesOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );

    // ---  إضافة أنيميشن الشريط هنا ---
    // يبدأ بعد ظهور النص ليكتمل في نهاية الأنيميشن
    _barWidthAnimation = Tween<double>(begin: 0.0, end: 220.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut), // المرحلة الأخيرة
      ),
    );

    _controller.forward();

    // تأخير الانتقال للصفحة الرئيسية
    Timer(const Duration(milliseconds: 4200), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // الدوائر الملونة (المرحلة الأولى)
            FadeTransition(
              opacity: _circlesOpacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(width: 200, height: 200, decoration: const BoxDecoration(color: AppColors.primaryPink, shape: BoxShape.circle)),
                    Container(width: 150, height: 150, decoration: const BoxDecoration(color: AppColors.accentYellow, shape: BoxShape.circle)),
                    Container(width: 100, height: 100, decoration: const BoxDecoration(color: AppColors.accentPurple, shape: BoxShape.circle)),
                  ],
                ),
              ),
            ),
            
            // النص والشريط تحته (المرحلتان الثانية والثالثة)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // النص
                FadeTransition(
                  opacity: _textOpacityAnimation,
                  child: Text(
                    'RAVAL',
                    style: TextStyle(
                      fontFamily: 'Exo2',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // --- الشريط المتدرج المتحرك ---
                // نستخدم AnimatedBuilder لإعادة بناء الشريط مع كل تغيير في قيمة الأنيميشن
                AnimatedBuilder(
                  animation: _barWidthAnimation,
                  builder: (context, child) {
                    return Container(
                      height: 4,
                      width: _barWidthAnimation.value, // <-- العرض يأتي من قيمة الأنيميشن
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primaryPink,
                            AppColors.accentYellow,
                            AppColors.accentPurple,
                            AppColors.accentTeal,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}