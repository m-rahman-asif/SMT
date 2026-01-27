import 'package:flutter/material.dart';
import 'package:smt/screens/languages_screen.dart';

class LocationScreen extends StatelessWidget {
  final String userId; // Add this

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
            // The Map/Location Image
            Image.asset(
              'assets/images/maps.png', // Placeholder for your map asset
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
            // Enable Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Logic to request actual GPS permission goes here
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Enable', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            // Skip Button
            TextButton(
              onPressed: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LanguageSelectionScreen(userId: userId)),
      ),
              child: const Text(
                'Skip, Not Now',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}