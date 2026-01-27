import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:smt/providers/login_provider.dart";
import "package:smt/providers/APIrepository.dart";
import 'package:smt/screens/forgot_password_screen';
import 'package:smt/screens/locations_screen.dart';
import 'package:smt/screens/signup_screen.dart';

// We use a ConsumerStatefulWidget so we can manage the lifecycle of our Controllers
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // 1. Declare the controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. Always dispose of controllers to prevent memory leaks
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rememberMe = ref.watch(rememberMeProvider);
    final isLoading =
        ref.watch(loginLoadingProvider); // Listen to loading state

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Image.asset('assets/images/login_logo.png', height: 100),
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
              controller: _emailController, // Attach controller
              decoration: InputDecoration(
                hintText: 'pristia@gmail.com',
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
              controller: _passwordController, // Attach controller
              obscureText: true,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.visibility_off_outlined),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),

            // Remember Me Row
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: const Text('Forgot Password')),
              ],
            ),
            const SizedBox(height: 30),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        ref.read(loginLoadingProvider.notifier).state = true;

                        try {
                          // 1. Call the login method from your repository
                          final response =
                              await ref.read(authRepositoryProvider).login(
                                    _emailController.text,
                                    _passwordController.text,
                                  );

                          if (mounted) {
                            // 2. If successful, navigate to the Location Screen or Dashboard
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationScreen()),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Login Failed: ${e.toString()}"),
                                  backgroundColor: Colors.red),
                            );
                          }
                        } finally {
                          ref.read(loginLoadingProvider.notifier).state = false;
                        }
                      }, // Disable button if loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white) // Show loader
                    : const Text('Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New to Theory Test?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text("Create Account"))
              ],
            )
          ],
        ),
      ),
    );
  }

  // Logic moved to a separate method for readability
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      await ref.read(authRepositoryProvider).login(email, password);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }
}
