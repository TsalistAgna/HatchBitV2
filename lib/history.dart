import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

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
                icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),

              const Text(
                'History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 16),

              // Gambar dan Level
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/mascot_1.png', height: 140),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Level 3/5',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // History list
              _buildHistoryItem('Reached Level 3', '19/9/1999'),
              const SizedBox(height: 8),
              _buildHistoryItem('Reached Level 2', '09/9/1999'),
              const SizedBox(height: 8),
              _buildHistoryItem('Reached Level 1', '09/9/1999'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            date,
            style: const TextStyle(color: Colors.deepPurple, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
