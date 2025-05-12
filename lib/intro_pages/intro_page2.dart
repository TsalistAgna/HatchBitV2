import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget{
  const IntroPage2({super.key});

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
              'Catch up on Habits, Collect Cute Mascot!',
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
                'assets/onboarding/ob_2.png',
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
              'Each egg that hatches brings a special surprise. Can you collect them all?',
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