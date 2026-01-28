import 'package:flutter_riverpod/flutter_riverpod.dart';



final rememberMeProvider = StateProvider<bool>((ref) => false);
final loginLoadingProvider = StateProvider<bool>((ref) => false);