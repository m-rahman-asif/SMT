import 'package:flutter/material.dart';
import 'package:smt/screens/login_screen.dart';
import "package:smt/widget_templates/onboarding_screen_template.dart";

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseOnboardingScreen(
      imagePath: 'assets/images/obs2.png',
      title: 'Explore your new skill\ntoday',
      description:
          "Our platform is designed to help you explore new skills. Let's learn & grow with Eduline!",
      buttonText: 'Get Started',
      currentIndex: 1,
      totalDots: 2,
      onButtonPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
    );
  }
}
