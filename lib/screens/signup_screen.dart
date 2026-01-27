import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:smt/providers/signup_provider.dart";
import "package:smt/providers/login_provider.dart";
import "package:smt/providers/APIrepository.dart";
import "package:smt/screens/locations_screen.dart";
import "package:smt/screens/login_screen.dart";
import "package:smt/widget_templates/success_dialog.dart";
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // Professional Logic: Update strength bar as user types
  void _checkPassword(String value) {
    double strength = 0;
    if (value.length >= 8) strength += 0.25;
    if (value.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (value.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;
    
    ref.read(passwordStrengthProvider.notifier).state = strength;
  }

 void _showSuccessDialog(BuildContext context, String id) { // Added String id
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SuccessDialog(
      imagePath: 'assets/images/success_signup.png',
      title: "Successfully Registered",
      subtitle: "Your account (ID: $id) has been registered successfully!", // Optional: use the id
      showCloseButton: true,
      onContinue: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final strength = ref.watch(passwordStrengthProvider);
    final isObscure = ref.watch(signUpObscureProvider);
    final isLoading = ref.watch(loginLoadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome to Eduline', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Let\'s join to Eduline learning ecosystem & meet our professional mentor. It\'s Free!', 
              style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),

            _buildField('Email Address', _emailController, 'pristia@gmail.com'),
            const SizedBox(height: 20),
            _buildField('Full Name', _nameController, 'Pristia Candra'),
            const SizedBox(height: 20),

            // Password Field
            const Text('Password', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _passController,
              obscureText: isObscure,
              onChanged: _checkPassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => ref.read(signUpObscureProvider.notifier).state = !isObscure,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 12),

            // Password Strength Indicator
            Row(
              children: List.generate(4, (index) => Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: strength > (index * 0.25) ? Colors.blue : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
            const SizedBox(height: 8),
           Row(
  crossAxisAlignment: CrossAxisAlignment.start, // Align icon with the first line of text
  children: [
    Icon(
      Icons.check_circle_outline, 
      size: 16, 
      color: strength >= 0.5 ? Colors.green : Colors.grey
    ),
    const SizedBox(width: 8),
    // THIS IS THE FIX:
    const Expanded( 
      child: Text(
        'At least 8 characters with a combination of letters and numbers', 
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ),
  ],
),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
               onPressed: isLoading ? null : () async {
  if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill in all fields")),
    );
    return;
  }

  ref.read(loginLoadingProvider.notifier).state = true;

  try {
    // FIX: Just CALL the method, don't define it here!
   final result = await ref.read(authRepositoryProvider).register(
  _nameController.text, 
  _emailController.text,
  _passController.text, // Add this third argument!
);

    if (mounted) { 
      // FIX: Add .toString() to the ID so it's always a String
      _showSuccessDialog(context, result['id'].toString());
    }

    print("API Response: $result");
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    }
  } finally {
    ref.read(loginLoadingProvider.notifier).state = false;
  }
},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ],
    );
  }
}