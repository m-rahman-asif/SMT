import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smt/providers/APIrepository.dart';
import 'package:smt/providers/login_provider.dart';
import 'package:smt/screens/verify_code_screen.dart';
import 'package:smt/widget_templates/success_dialog.dart';



class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  final String token; // Added token field

  const ResetPasswordScreen({
    super.key, 
    required this.email, 
    required this.token, // Added to constructor
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(leading: const BackButton(color: Colors.black), elevation: 0, backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text("Reset Password", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text("Your password must be at least 8 characters long and include a combination of letters, numbers",
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 32),
            _buildPasswordField("New Password", _newPassController, _isObscureNew, () => setState(() => _isObscureNew = !_isObscureNew)),
            const SizedBox(height: 20),
            _buildPasswordField("Confirm New Password", _confirmPassController, _isObscureConfirm, () => setState(() => _isObscureConfirm = !_isObscureConfirm)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6DFB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text("Submit", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscure, VoidCallback onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            suffixIcon: IconButton(icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: onToggle),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey.shade200)),
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
    // Calling the API with the token we got from the code screen
    await ref.read(authRepositoryProvider).completePasswordReset(
      widget.email, 
      widget.token, 
      _newPassController.text
    );

    if (mounted) {
      // Since you don't want a success dialog, we go back to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Success! Please login with your new password."), backgroundColor: Colors.green),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  } catch (e) {
    _showError(e.toString());
  } finally {
    ref.read(loginLoadingProvider.notifier).state = false;
  }
}
}