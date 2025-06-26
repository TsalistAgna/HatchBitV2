import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Model buat simpen data leaderboard
class LeaderboardEntry {
  final String uid;
  final String username;
  final int completedTasks;
  int rank;

  LeaderboardEntry({
    required this.uid,
    required this.username,
    required this.completedTasks,
    this.rank = 0,
  });
}

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late Future<List<LeaderboardEntry>> _leaderboardFuture;
  final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _leaderboardFuture = _fetchAndProcessLeaderboard();
  }

  Future<List<LeaderboardEntry>> _fetchAndProcessLeaderboard() async {
    // Ambil semua data pengguna
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    final usersMap = {for (var doc in usersSnapshot.docs) doc.id: doc.data()['username'] ?? 'No Name'};

    // Ambil semua habit yang udah selese
    final habitsSnapshot = await FirebaseFirestore.instance
        .collection('habits')
        .where('isCompleted', isEqualTo: true)
        .get();

    // Hitung jumlah habit yang selese untuk masing masing pengguna
    final taskCounts = <String, int>{};
    for (var habit in habitsSnapshot.docs) {
      final uid = habit.data()['uid'] as String?;
      if (uid != null) {
        taskCounts[uid] = (taskCounts[uid] ?? 0) + 1;
      }
    }

    // Buat daftar leaderboard
    var allEntries = usersMap.entries.map((entry) {
      final uid = entry.key;
      final username = entry.value;
      final count = taskCounts[uid] ?? 0;
      return LeaderboardEntry(uid: uid, username: username, completedTasks: count);
    }).toList();

    // Urutin leaderboardnya
    allEntries.sort((a, b) => b.completedTasks.compareTo(a.completedTasks));

    for (int i = 0; i < allEntries.length; i++) {
      allEntries[i].rank = i + 1;
    }

    // List isinya rank yang udah diurutin siap dipake
    List<LeaderboardEntry> displayList = allEntries.take(10).toList();
    LeaderboardEntry? currentUserEntry;

    // Cari user yang login saat ini di daftar
    if (currentUserUid != null) {
      try {
        currentUserEntry = allEntries.firstWhere((entry) => entry.uid == currentUserUid);
      } catch (e) {
        currentUserEntry = null;
      }
    }

    // Ini kalo dia ga 10 besar
    if (currentUserEntry != null && currentUserEntry.rank > 10) {
      displayList.add(currentUserEntry);
    }

    return displayList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Leaderboard', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png', width: 40, height: 40),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<LeaderboardEntry>>(
        future: _leaderboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          }

          final leaderboard = snapshot.data!;

          return ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              final entry = leaderboard[index];
              final isCurrentUser = entry.uid == currentUserUid;

              if (index == 10 && isCurrentUser) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Row(
                        children: [
                          Icon(Icons.more_vert, color: Colors.grey),
                          Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                        ],
                      ),
                    ),
                    _buildRankItem(entry, isCurrentUser),
                  ],
                );
              }

              return _buildRankItem(entry, isCurrentUser);
            },
          );
        },
      ),
    );
  }

  Widget _buildRankItem(LeaderboardEntry entry, bool isCurrentUser) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.deepPurple.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser ? Border.all(color: Colors.deepPurple, width: 2) : null,
      ),
      child: Row(
        children: [
          // Rank
          Text(
            '#${entry.rank}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isCurrentUser ? Colors.deepPurple : Colors.black87,
            ),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (isCurrentUser)
                  const Text(
                    'Your Rank',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Task count
          Row(
            children: [
              Text(
                '${entry.completedTasks}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}