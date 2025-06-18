import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/login_page.dart';

import 'history.dart';
import 'setting.dart';
import 'home_screen.dart';
import 'about_us.dart';
import 'addTask.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int completedCount = 0;
  String username = '';

  @override
  void initState() {
    super.initState();
    fetchCompletedTaskCount();
    getUserName();
  }

  void getUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          username = doc.data()?['username'] ?? '';
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCompletedTaskCount();
  }

  void fetchCompletedTaskCount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('habits')
        .where('uid', isEqualTo: uid)
        .where('isCompleted', isEqualTo: true)
        .get();

    setState(() {
      completedCount = snapshot.docs.length;
    });
  }

  int getLevel(int count) {
    if (count > 100) return 5;
    if (count > 75) return 4;
    if (count > 50) return 3;
    if (count > 20) return 2;
    return 1;
  }

  int getNextLevelTarget(int currentLevel) {
    switch (currentLevel) {
      case 1:
        return 50;
      case 2:
        return 75;
      case 3:
        return 100;
      case 4:
        return 101;
      case 5:
        return completedCount;
      default:
        return 20;
    }
  }

  String getLevelName(int level) {
    switch (level) {
      case 0:
        return 'Baby Hatchbit';
      case 1:
        return 'Beginner Hatchbit';
      case 2:
        return 'Rising Hatchbit';
      case 3:
        return 'Pro Hatchbit';
      case 4:
        return 'Master Hatchbit';
      case 5:
        return 'Legendary Hatchbit';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = getLevel(completedCount);
    final nextLevelTarget = getNextLevelTarget(level);
    final progress = completedCount /
        (level == 5 ? completedCount : nextLevelTarget);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        index: 2,
        backgroundColor: Colors.white,
        color: Colors.deepPurple,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddHabitPage()),
            );
          }
        },
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.add, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      username.isNotEmpty ? username : 'User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      getLevelName(level),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/mascot_${(level.clamp(1, 5))}.png', // level 0 pakai mascot_1
                      height: 130,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Level', style: TextStyle(fontSize: 16)),
                      Text('$level', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 24,
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: Colors.purple.shade100,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$completedCount/$nextLevelTarget Task',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                },
                icon: const Icon(Icons.history, color: Colors.white),
                label: const Text('History', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SettingScreen()),
                  );
                },
                icon: const Icon(Icons.settings, color: Colors.white),
                label: const Text('Setting', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                          (Route<dynamic> route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),


              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutUsPage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'About Us',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.white30,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.copyright, size: 16, color: Colors.white70),
                          SizedBox(width: 6),
                          Text(
                            'PMAAF Studio 2025',
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
