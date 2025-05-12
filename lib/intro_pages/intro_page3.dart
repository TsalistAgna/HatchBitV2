import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget{
  const IntroPage3({super.key});

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
              'Ready to Hatch Your New Habit?',
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
                'assets/onboarding/ob_3.png',
                height: 250,
              ),
            ),
          ),

          // Bottom text
          Positioned(
            bottom: 280,
            left: 30,
            right: 30,
            child: Text(
              'Start now and see the small changes that make a big impact!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}