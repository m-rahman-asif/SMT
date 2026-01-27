import 'package:flutter_riverpod/flutter_riverpod.dart';


// Simple provider for the Remember Me checkbox
final rememberMeProvider = StateProvider<bool>((ref) => false);

// Provider to manage loading state during sign-in
final loginLoadingProvider = StateProvider<bool>((ref) => false);