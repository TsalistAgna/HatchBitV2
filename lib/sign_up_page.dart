import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/global/toast.dart';
import 'package:project_mobile/home_screen.dart';
import 'package:project_mobile/login_page.dart';
import 'package:project_mobile/user_auth/firebase_auth/firebase_auth_services.dart';
import 'package:project_mobile/verifikasi_email.dart';
import 'package:project_mobile/widgets/form_container_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome! Register to start\nhatching!",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3D1B76),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FormContainerWidget(
                    hintText: "Username",
                    isPasswordField: false,
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 15),
                  FormContainerWidget(
                    hintText: "Email",
                    isPasswordField: false,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 15),
                  FormContainerWidget(
                    hintText: "Password",
                    isPasswordField: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 15),
                  FormContainerWidget(
                    hintText: "Confirm Password",
                    isPasswordField: true,
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      _signUp();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Color(0xFF3D1B76),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child:
                            isSigningUp
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Register",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            color: Color(0xFF3D1B76),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showToasts(message: "Some fields can't be empty!");
      return;
    }

    if (password != confirmPassword) {
      showToasts(message: "Passwords don't match!");
      return;
    }

    setState(() {
      isSigningUp = true;
    });

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      // showToasts(message: "User is successfully created");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HalamanVerifikasiEmail()),
        (route) => false,
      );
    } else {
      showToasts(message: "Some error happened during sign up!!");
    }
  }
}
