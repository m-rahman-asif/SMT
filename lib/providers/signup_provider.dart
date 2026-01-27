import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tracks the strength level (0 to 4)
final passwordStrengthProvider = StateProvider<double>((ref) => 0.0);

// Simple boolean for password visibility
final signUpObscureProvider = StateProvider<bool>((ref) => true);