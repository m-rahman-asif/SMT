import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:smt/providers/login_provider.dart";
import "package:smt/providers/APIrepository.dart";
import 'package:smt/screens/forgot_password_screen.dart';
import 'package:smt/screens/locations_screen.dart';
import 'package:smt/screens/signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      final result =
          await ref.read(authRepositoryProvider).login(email, password);
      if (mounted) {
        final userId = result['user_id']?.toString() ??
            result['id']?.toString() ??
            'unknown';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LocationScreen(userId: userId),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rememberMe = ref.watch(rememberMeProvider);
    final isLoading = ref.watch(loginLoadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Image.asset('assets/images/bulb_book.png', height: 100),
            const SizedBox(height: 24),
            const Text('Welcome Back!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('Please login first to start your Theory Test.',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),

            // Email Field
            const Align(
                alignment: Alignment.centerLeft, child: Text('Email Address')),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email here',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 20),

            // Password Field
            const Align(
                alignment: Alignment.centerLeft, child: Text('Password')),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (val) =>
                      ref.read(rememberMeProvider.notifier).state = val!,
                ),
                const Text('Remember Me'),
                const Spacer(),
                TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ForgotPasswordScreen())),
                    child: const Text('Forgot Password')),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),

            //const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New to Theory Test?"),
                TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen())),
                    child: const Text("Create Account"))
              ],
            ),
            //const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
