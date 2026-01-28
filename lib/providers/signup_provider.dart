import 'package:flutter_riverpod/flutter_riverpod.dart';


final passwordStrengthProvider = StateProvider<double>((ref) => 0.0);

final signUpObscureProvider = StateProvider<bool>((ref) => true);