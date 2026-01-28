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

  void _checkPassword(String value) {
    double strength = 0;
    if (value.length >= 8) strength += 0.25;
    if (value.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (value.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    ref.read(passwordStrengthProvider.notifier).state = strength;
  }

  void _showSuccessDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        imagePath: 'assets/images/success_signup.png',
        title: "Successfully Registered",
        subtitle:
            "Your account has been registered successfully, now let's enjoy our features!",
        showCloseButton: true,
        onContinue: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
            const Text('Welcome to Eduline',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
                'Let\'s join to Eduline learning ecosystem & meet our professional mentor. It\'s Free!',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildField('Email Address', _emailController, 'Enter your email'),
            const SizedBox(height: 20),
            _buildField('Full Name', _nameController, 'Enter your name'),
            const SizedBox(height: 20),
            const Text('Password',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _passController,
              obscureText: isObscure,
              onChanged: _checkPassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon:
                      Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => ref
                      .read(signUpObscureProvider.notifier)
                      .state = !isObscure,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                  4,
                  (index) => Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: strength > (index * 0.25)
                                ? Colors.blue
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      )),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline,
                    size: 16,
                    color: strength >= 0.5 ? Colors.green : Colors.grey),
                const SizedBox(width: 8),
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
                onPressed: isLoading
                    ? null
                    : () async {
                        final String nameValue = _nameController.text.trim();
                        final String emailValue =
                            _emailController.text.trim().toLowerCase();
                        final String passwordValue =
                            _passController.text.trim();

                        print(
                            "BUTTON TAP -> Name: '$nameValue', Email: '$emailValue'");

                        if (emailValue.isEmpty ||
                            nameValue.isEmpty ||
                            passwordValue.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill in all fields")),
                          );
                          return;
                        }

                        ref.read(loginLoadingProvider.notifier).state = true;

                        try {
                          final result =
                              await ref.read(authRepositoryProvider).register(
                                    nameValue,
                                    emailValue,
                                    passwordValue,
                                  );

                          if (mounted) {
                            _showSuccessDialog(
                                context, result['id']?.toString() ?? 'Success');
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        } finally {
                          ref.read(loginLoadingProvider.notifier).state = false;
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textInputAction: TextInputAction.next,
          onChanged: (value) => {},
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ],
    );
  }
}
