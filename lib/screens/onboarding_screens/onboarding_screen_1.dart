import 'package:flutter/material.dart';
import "package:smt/screens/onboarding_screens/onboarding_screen_2.dart";
import "package:smt/widget_templates/onboarding_screen_template.dart";


class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseOnboardingScreen(
      imagePath: 'assets/images/obs1.png',
      title: 'Best online courses\nin the world',
      description: 'Now you can learn anywhere, anytime, even if there is no internet access!',
      buttonText: 'Next',
      currentIndex: 0,
      totalDots: 2,
      onButtonPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen2()),
        );
      },
    );
  }
}