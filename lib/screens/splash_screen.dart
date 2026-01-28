import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:smt/providers/splash_screen_provider.dart";
import 'package:smt/screens/onboarding_screens/onboarding_screen_1.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(splashScreenProvider, (previous, next) {
      if (next.hasValue && next.value == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen1()),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Image.asset('assets/images/car.png'),
              const SizedBox(height: 40),
              const Text(
                'Theory test in my language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'I must write the real test will be in English language and this app just helps you to understand the materials in your language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),
              const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
