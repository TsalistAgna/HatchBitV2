import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    _addHistoryEntry();
  }

  // Fungsi untuk hitung level dari jumlah task selesai
  int getLevel(int count) {
    if (count > 100) return 5;
    if (count > 75) return 4;
    if (count > 50) return 3;
    if (count > 20) return 2;
    return 1;
  }

  // Menambahkan entri history jika level baru belum tercatat
  void _addHistoryEntry() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;

      // Ambil jumlah task selesai user
      final completedTasksSnapshot = await FirebaseFirestore.instance
          .collection('habits')
          .where('uid', isEqualTo: uid)
          .where('isCompleted', isEqualTo: true)
          .get();

      final completedCount = completedTasksSnapshot.size;
      final currentLevel = getLevel(completedCount);

      // Dokumen unik berdasarkan uid dan level
      final docRef = FirebaseFirestore.instance
          .collection('level_history')
          .doc('$uid-level$currentLevel');

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        await docRef.set({
          'uid': uid,
          'level': currentLevel,
          'timestamp': Timestamp.now(),
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Image.asset('assets/icons/back.png', width: 40, height: 40),
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
              const SizedBox(height: 24),
              Expanded(
                child: uid == null
                    ? const Center(child: Text('User tidak ditemukan.'))
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('level_history')
                            .where('uid', isEqualTo: uid)
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          final historyDocs = snapshot.data?.docs ?? [];

                          if (historyDocs.isEmpty) {
                            return const Center(child: Text('Belum ada riwayat level.'));
                          }

                          return ListView.builder(
                            itemCount: historyDocs.length,
                            itemBuilder: (context, index) {
                              final data = historyDocs[index].data() as Map<String, dynamic>;
                              final level = data['level'] ?? 1;
                              final timestamp = (data['timestamp'] as Timestamp).toDate();
                              final formattedDate =
                                  '${timestamp.day}/${timestamp.month}/${timestamp.year}';

                              return _buildHistoryItem('Reached Level $level', formattedDate);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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