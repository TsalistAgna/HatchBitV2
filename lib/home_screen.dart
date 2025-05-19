import 'package:flutter/material.dart';
import 'task_with_timer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                taskDuration: 1, //
              )),
            );
          },
          child: const Text('Next'),
        ),
      ),
    );
  }
}