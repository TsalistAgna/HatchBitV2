import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_mobile/home_screen.dart';

class TaskWithTimer extends StatefulWidget {
  final String taskName; // nama task
  final int taskDuration; // dalam menit

  const TaskWithTimer({
    super.key,
    required this.taskName,
    required this.taskDuration,
  });

  @override
  State<TaskWithTimer> createState() => _TaskWithTimerState();
}

class _TaskWithTimerState extends State<TaskWithTimer> {
  late int remainingSeconds;
  Timer? timer;
  bool isRunning = false;
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.taskDuration * 60;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        setState(() {
          isRunning = false;
          isDone = true;
        });
        timer?.cancel();
      }
    });
    setState(() {
      isRunning = true;
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  String formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 53, left: 16, right: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      }
                  ),
                  Text(
                    widget.taskName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Image.asset(
              'assets/mascot.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 30),
            Text(
              formatTime(remainingSeconds),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isDone
                  ? null
                  : isRunning
                  ? pauseTimer
                  : startTimer,
              child: Text(
                isDone
                    ? "Done"
                    : isRunning
                    ? "Pause"
                    : "Start Timer",
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
