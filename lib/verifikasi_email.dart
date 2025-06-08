import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_mobile/global/toast.dart';
import 'package:project_mobile/home_screen.dart';
import 'package:project_mobile/login_page.dart';

class HalamanVerifikasiEmail extends StatefulWidget {
  const HalamanVerifikasiEmail({super.key});

  @override
  State<HalamanVerifikasiEmail> createState() => _HalamanVerifikasiEmailState();
}

class _HalamanVerifikasiEmailState extends State<HalamanVerifikasiEmail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isResendingEmail = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user == null) {
      // Kalo dah logout, balikin ke login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      });
    } else {
      // cek status verify emailnya
      _checkEmailVerificationStatus();
    }
  }

  Future<void> _checkEmailVerificationStatus() async {
    await _user?.reload();
    _user = _auth.currentUser;
    if (_user != null && _user!.emailVerified) {
      showToasts(message: "Email Anda wes terverifikasi!");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _sendVerificationEmail() async {
    setState(() {
      _isResendingEmail = true;
    });
    try {
      await _user?.sendEmailVerification();
      showToasts(message: "Email verifikasi baru telah dikirim!");
    } on FirebaseAuthException catch (e) {
      showToasts(message: "Gagal mengirim email: ${e.message}");
    } finally {
      setState(() {
        _isResendingEmail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email_outlined, size: 100, color: Color(0xFF3D1B76)),
                SizedBox(height: 30),
                Text(
                  "Verifikasi Email Anda",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D1B76),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Kami telah mengirimkan tautan verifikasi ke email Anda:",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _user?.email ?? "Email invalid!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D1B76),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Silakan periksa kotak masuk atau folder spam Anda dan klik tautan untuk melanjutkan.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 40),
                GestureDetector(
                  onTap: _isResendingEmail ? null : _sendVerificationEmail,
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color:
                          _isResendingEmail ? Colors.grey : Color(0xFF3D1B76),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child:
                          _isResendingEmail
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                "Kirim Ulang Email Verifikasi",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    _checkEmailVerificationStatus();
                  },
                  child: Text(
                    "Saya Sudah Verifikasi",
                    style: GoogleFonts.poppins(
                      color: Color(0xFF3D1B76),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                    showToasts(
                      message: "Anda telah logout, silahkan login lagi.",
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Logout",
                    style: GoogleFonts.poppins(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
