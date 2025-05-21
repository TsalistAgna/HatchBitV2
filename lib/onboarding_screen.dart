import 'package:flutter/material.dart';
import 'package:project_mobile/home_screen.dart';
import 'package:project_mobile/login_page.dart';
import 'package:project_mobile/task_with_timer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'intro_pages/intro_page1.dart';
import 'intro_pages/intro_page2.dart';
import 'intro_pages/intro_page3.dart';
import 'intro_pages/intro_page4.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for intro pages
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 3);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
            ],
          ),

          // Bottom controls (Skip, Indicator, Next/Done)
          Positioned(
            bottom: 80,
            left: 40,
            right: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip
                GestureDetector(
                  onTap: () => _controller.jumpToPage(3),
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),

                // Dot Indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: WormEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.white,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),

                // Next or Done
                GestureDetector(
                  onTap: () {
                    if (onLastPage) {
                      // TODO: PINJEM BENTAR
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LoginPage()),
                      // );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text(
                    onLastPage ? 'Done' : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}