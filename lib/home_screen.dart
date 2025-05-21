import 'package:flutter/material.dart';
import 'task_with_timer.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.deepPurple,
        onTap: (index){
          // Handle button tap
          if (index == 0) {
            // Navigate to home screen
          } else if (index == 1) {
            // Navigate to add task screen
          } else if (index == 2) {
            // Navigate to profile screen
          }
        },
        items: [
        Icon(
          Icons.home,
          color: Colors.white,
          ),
        Icon(
          Icons.add,
          color: Colors.white,
          ),
        Icon(
          Icons.person,
          color: Colors.white,
          ),
      ]
      ),

      appBar: AppBar(
        title: const Text('HatchBit'),
        backgroundColor: Colors.purple.shade200, // opsional, bisa diganti sesuai tema kamu
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TaskWithTimer(
                taskName: "Read A Book", //
                taskDuration: 5, //
              )),
            );
          },
          child: const Text('Next'),
        ),
      ),
    );
  }
}