import 'package:flutter/material.dart';
import 'dart:async';

import 'package:smt/widget_templates/success_dialog.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  const VerifyCodeScreen({super.key, required this.email});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  Timer? _timer;
  int _secondsRemaining = 180; // Total seconds (3 minutes)

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer?.cancel();
          }
        });
      }
    });
  }

  void _showSuccessDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SuccessDialog(
      imagePath: 'assets/images/success_verification.png',
      title: "Success",
      subtitle: "Your password is successfully\ncreated",
      onContinue: () {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
    ),
  );
}
  void _verifyOtp(String otp) {
    // In a real app, you would validate the OTP against your API here
    print("Verifying OTP: $otp");

    // If verification is successful:
    _showSuccessDialog();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- MATH FOR THE DISPLAY ---
    // This calculates how many full minutes are left
    int minutes = _secondsRemaining ~/ 60; 
    // This calculates the remaining seconds after minutes are taken out
    int seconds = _secondsRemaining % 60; 

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0,
            child: TextField(
              controller: _otpController,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              maxLength: 4,
              onChanged: (value) {
                setState(() {}); 
                if (value.length == 4) {
                  _verifyOtp(value);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Text("Verify Code", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  "Please enter the code we just sent to\nemail ${widget.email}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey.shade300, fontSize: 14),
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () => _focusNode.requestFocus(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) => _buildDigitBox(index)),
                  ),
                ),
                const SizedBox(height: 40),
                
                // --- UPDATED TIMER TEXT ---
                Text(
                  "Resend code in ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDigitBox(int index) {
    bool isFilled = _otpController.text.length > index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isFilled ? const Color(0xFF1A6DFB) : Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: Center(
        child: isFilled 
          ? const Icon(Icons.circle, size: 14, color: Colors.black)
          : null,
      ),
    );
  }

  
}