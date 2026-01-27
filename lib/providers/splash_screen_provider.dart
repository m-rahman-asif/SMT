import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashScreenProvider = FutureProvider<bool>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  return true;
});