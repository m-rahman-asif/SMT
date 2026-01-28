import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smt/providers/APIrepository.dart';
import 'package:smt/providers/login_provider.dart';
import 'package:smt/widget_templates/success_dialog.dart';
import 'package:smt/screens/login_screen.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  final String token;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        imagePath: 'assets/images/success_verification.png',
        title: "Success",
        subtitle: "Your password is successfully changed",
        showCloseButton: false,
        onContinue: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text("Reset Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "Your password must be at least 8 characters long and include a combination of letters and numbers",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),
            _buildPasswordField(
              "New Password",
              _newPassController,
              _isObscureNew,
              () => setState(() => _isObscureNew = !_isObscureNew),
            ),
            const SizedBox(height: 20),
            _buildPasswordField(
              "Confirm New Password",
              _confirmPassController,
              _isObscureConfirm,
              () => setState(() => _isObscureConfirm = !_isObscureConfirm),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text("Submit",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool obscure, VoidCallback onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: onToggle),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() async {
    if (_newPassController.text != _confirmPassController.text) {
      _showError("Passwords do not match!");
      return;
    }

    if (_newPassController.text.length < 8) {
      _showError("Password too short!");
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;
    try {
      await ref.read(authRepositoryProvider).completePasswordReset(
            widget.email,
            widget.token,
            _newPassController.text,
          );

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        ref.read(loginLoadingProvider.notifier).state = false;
      }
    }
  }
}
