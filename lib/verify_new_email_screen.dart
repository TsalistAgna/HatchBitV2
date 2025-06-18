import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/global/toast.dart';
import 'package:project_mobile/user_auth/firebase_auth/firebase_auth_services.dart';
import 'package:project_mobile/login_page.dart';

class VerifyNewEmailScreen extends StatefulWidget {
  final String newEmail;
  const VerifyNewEmailScreen({required this.newEmail, super.key});

  @override
  State<VerifyNewEmailScreen> createState() => _VerifyNewEmailScreenState();
}

class _VerifyNewEmailScreenState extends State<VerifyNewEmailScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  late Timer _timer;
  bool _isCheckingStatus = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isCheckingStatus) {
        _checkVerificationStatus();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _checkVerificationStatus() async {
    setState(() {
      _isCheckingStatus = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      print("Checking status: Current user email is ${user?.email}");

      if (user == null) {
        _timer.cancel();
        showToasts(
            message: "Sesi Anda telah berakhir. Silakan login kembali.",);

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
          );
        }
        return;
      }

      if (user?.email == widget.newEmail) {
        _timer.cancel();

        await _authService.synchronizeUserData();

        showToasts(
            message:
            "Email berhasil diverifikasi! Silakan login dengan email baru Anda.");

        await _authService.signOut();

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print("Error during verification check: ${e.code} - ${e.message}");
    } catch (e) {
      print("An unexpected error occurred: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingStatus = false;
        });
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    try {
      await _authService.updateUserEmail(widget.newEmail);
      showToasts(message: "Verification email has been resent.");
    } on FirebaseAuthException catch (e) {
      showToasts(message: "Error: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Verify Your New Email"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.mark_email_read_outlined, size: 100, color: Colors.deepPurple),
              const SizedBox(height: 24),
              const Text(
                "Dikit lagi bro!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Kami udah ngirim link verifikasi ke:\n${widget.newEmail}\n\nCek inbox dan klik pada link untuk lanjut!!",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (_isCheckingStatus)
                const CircularProgressIndicator(color: Colors.deepPurple)
              else
                ElevatedButton.icon(
                  onPressed: _checkVerificationStatus,
                  icon: const Icon(Icons.refresh),
                  label: const Text("I've Verified, Check Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),

              const SizedBox(height: 16),
              Text(
                _isCheckingStatus ? "Checking status now..." : "Waiting for verification...",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _resendVerificationEmail,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text("Resend Verification Email"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.withOpacity(0.8),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel and Go Back", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}