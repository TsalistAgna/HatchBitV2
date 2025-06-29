import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'home_screen.dart';
import 'addTask.dart';
import 'profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    AddHabitPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent, 
        color: Colors.deepPurple,
        animationDuration: const Duration(milliseconds: 300),
        index: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
        items: const [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.add, color: Colors.white, size: 30),
          Icon(Icons.person, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}