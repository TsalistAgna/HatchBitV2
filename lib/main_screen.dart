// main_screen.dart

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// Import ketiga halaman utama Anda
import 'home_screen.dart';
import 'addTask.dart'; // File ini berisi kelas AddHabitPage
import 'profile.dart';   // File ini berisi kelas ProfileScreen

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Variabel untuk melacak halaman yang sedang aktif
  int _pageIndex = 0;

  // Siapkan daftar halaman yang akan ditampilkan
  final List<Widget> _pages = const [
    HomeScreen(),    // Halaman di index 0
    AddHabitPage(),  // Halaman di index 1
    ProfileScreen(), // Halaman di index 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body sekarang akan secara dinamis menampilkan halaman dari list _pages
      // berdasarkan _pageIndex yang aktif.
      body: _pages[_pageIndex],

      // Ini adalah SATU-SATUNYA CurvedNavigationBar di aplikasi Anda.
      bottomNavigationBar: CurvedNavigationBar(
        // Gunakan transparent agar body di belakang kurva bisa terlihat
        backgroundColor: Colors.transparent, 
        color: Colors.deepPurple,
        animationDuration: const Duration(milliseconds: 300),
        index: _pageIndex, // Bind index navbar dengan state
        onTap: (index) {
          // Ketika item di-tap, kita hanya perlu mengubah state dengan setState
          // Flutter akan otomatis membangun ulang body dengan halaman yang benar
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