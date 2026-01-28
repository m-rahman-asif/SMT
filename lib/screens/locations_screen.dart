import 'package:flutter/material.dart';
import 'package:smt/screens/languages_screen.dart';

class LocationScreen extends StatelessWidget {
  final String userId;

  const LocationScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/maps.png',
              height: 200,
            ),
            const SizedBox(height: 40),
            const Text(
              'Enable Location',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kindly allow us to access your location to provide you with suggestions for nearby salons',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Enable',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LanguageSelectionScreen(userId: userId)),
              ),
              child: const Text(
                'Skip, Not Now',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
