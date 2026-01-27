import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tracks the current page index (0, 1, etc.)
final onboardingScreensProvider = StateProvider<int>((ref) => 0);