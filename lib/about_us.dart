import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(MaterialApp(home: AboutUsPage(), debugShowCheckedModeBanner: false));
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('assets/icons/back.png', width: 40, height: 40),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.deepPurple),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const SizedBox(height: 20),

            // Logo & Title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Image.asset('assets/mascot_1.png', width: 40),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "P MAAF",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "PMAAF is a team that focuses on mobile application development.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description
            Text("Hi,", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              "We are students from Informatics Engineering Department at University of Mataram. We created this app as final project of Mobile Programming Course.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/placeholder_grup.png'),
            ),
            const SizedBox(height: 24),

            // Development Team Title
            Text(
              "Development Team",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Team Members
            Wrap(
              spacing: 16,
              runSpacing: 20,
              children: [
                teamMember("I Gede Pandu G. P.", "Role", 'assets/mascot_2.png'),
                teamMember(
                  "Baiq Annisa Tsalist A.",
                  "Role",
                  'assets/mascot_3.png',
                ),
                teamMember(
                  "Gusti Ayu Devi A. P.",
                  "Role",
                  'assets/mascot_4.png',
                ),
                teamMember("Michael Effendy", "Role", 'assets/mascot_5.png'),
                teamMember(
                  "Fadila Ramdhani Muaz",
                  "Role",
                  'assets/mascot_1.png',
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget teamMember(String name, String role, String imgPath) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imgPath,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(name, textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(role, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}
