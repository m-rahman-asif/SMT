import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:smt/providers/language_provider.dart";
import 'package:flutter/material.dart';
import "package:smt/models/language_model.dart";

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCode = ref.watch(selectedLanguageProvider);

    // Mock data based on your image
    final List<Language> languages = [
      Language(name: 'English (US)', flagAsset: '🇺🇸', code: 'en'),
      Language(name: 'Indonesia', flagAsset: '🇮🇩', code: 'id'),
      Language(name: 'Afghanistan', flagAsset: '🇦🇫', code: 'af'),
      Language(name: 'Algeria', flagAsset: '🇩🇿', code: 'dz'),
      Language(name: 'Malaysia', flagAsset: '🇲🇾', code: 'my'),
      Language(name: 'Arabic', flagAsset: '🇦🇪', code: 'ar'),
    ];

    return Scaffold(
      appBar: AppBar(leading: const BackButton(), elevation: 0, backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What is Your Mother Language", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Discover what is a podcast description and podcast summary.",
              style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  final isSelected = selectedCode == lang.code;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Text(lang.flagAsset, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 16),
                        Expanded(child: Text(lang.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                        ElevatedButton(
                          onPressed: () => ref.read(selectedLanguageProvider.notifier).state = lang.code,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? Colors.blue : Colors.grey.shade100,
                            foregroundColor: isSelected ? Colors.white : Colors.grey,
                            elevation: 0,
                            shape: StadiumBorder(),
                          ),
                          child: Text(isSelected ? '✓ Selected' : 'Select'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // HERE is your UPDATE operation
                  // ref.read(authRepositoryProvider).updateUser(userId, {'language': selectedCode});
                  Navigator.pushNamed(context, '/location');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}