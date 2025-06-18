import 'package:flutter/material.dart';
import 'package:project_mobile/login_page.dart';
import 'package:project_mobile/sign_up_page.dart';

class IntroPage4 extends StatelessWidget{
  const IntroPage4({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFF6A4FA3),
      body: Stack(
        children: [
          // Top text
          Positioned(
            top: 180,
            left: 30,
            right: 30,
            child: Text(
              'Hatch Your Habits, Unlock the Rewards',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Center image
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/hatching.png',
                height: 250,
              ),
            ),
          ),

          // Bottom text
          Column(
            children: [
              const Spacer(),

              // Tombol Get Started di tengah dan tidak full
              Center(
                child: SizedBox(
                  width: 330, // atur lebar tombol
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6A4FA3),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Link "I already have an account"
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text(
                  'I already have an account',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 220),
            ],
          )
        ],
      ),
    );
  }
}