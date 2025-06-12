import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 8),

              const Text(
                'Edit Profile Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 24),

              // Username
              const Text(
                'Username',
                style: TextStyle(color: Colors.deepPurple),
              ),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: 'mike123', // contoh
                decoration: _inputDecoration(),
              ),

              const SizedBox(height: 16),

              // Email
              const Text('Email', style: TextStyle(color: Colors.deepPurple)),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: 'mike123@gmail.com', // contoh
                decoration: _inputDecoration(),
              ),

              const SizedBox(height: 16),

              // Password
              const Text(
                'Password',
                style: TextStyle(color: Colors.deepPurple),
              ),
              const SizedBox(height: 6),
              TextFormField(
                obscureText: true,
                decoration: _inputDecoration(
                  hint:
                      'Fill this field only if you want to change the password',
                ),
              ),

              const SizedBox(height: 16),

              // Confirm Password
              const Text(
                'Confirm Password',
                style: TextStyle(color: Colors.deepPurple),
              ),
              const SizedBox(height: 6),
              TextFormField(
                obscureText: true,
                decoration: _inputDecoration(
                  hint:
                      'Fill this field only if you want to change the password',
                ),
              ),

              const SizedBox(height: 28),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Simpan data profile
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
