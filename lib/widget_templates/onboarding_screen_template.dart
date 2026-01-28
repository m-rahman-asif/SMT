import 'package:flutter/material.dart';

class BaseOnboardingScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String buttonText;
  final int currentIndex;
  final int totalDots;
  final VoidCallback onButtonPressed;

  const BaseOnboardingScreen({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.currentIndex,
    required this.totalDots,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Illustration
            Expanded(
              flex: 5,
              child: Center(
                child: Image.asset(
                  imagePath,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        totalDots,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: currentIndex == index ? 12 : 8,
                          decoration: BoxDecoration(
                            color: currentIndex == index
                                ? Colors.blue
                                : Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6DFB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
