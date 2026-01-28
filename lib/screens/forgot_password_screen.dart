import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smt/providers/APIrepository.dart';
import 'package:smt/providers/login_provider.dart';
import 'package:smt/screens/reset_password_screen.dart';
import 'package:smt/screens/verify_code_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginLoadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Forgot Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Enter your email, we will send a\nverification code to email',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 40),
            const Text('Email Address',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleReset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Continue',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Valid email required")));
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;
    try {
      await ref.read(authRepositoryProvider).requestPasswordReset(email);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyCodeScreen(email: email)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }
}
