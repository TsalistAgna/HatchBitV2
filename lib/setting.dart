import 'package:flutter/material.dart';
import 'edit_profile.dart';
import 'profile.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol kembali
              IconButton(
                icon: Image.asset('assets/icons/back.png', width: 40, height: 40),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),

              const SizedBox(height: 8),

              const Text(
                'Setting',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 24),

              // Section: Account
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.person, color: Colors.white),
                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Section: Preferences
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preferences',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _preferenceTile(),
                    const SizedBox(height: 8),
                    _preferenceTile(),
                    const SizedBox(height: 8),
                    _preferenceTile(),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _preferenceTile(),
              const SizedBox(height: 8),
              _preferenceTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _preferenceTile() {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
