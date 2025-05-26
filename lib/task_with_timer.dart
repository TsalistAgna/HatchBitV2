import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_mobile/home_screen.dart';

class TaskWithTimer extends StatefulWidget {
  final String taskName; // nama task
  final int taskDuration; // dalam menit
  final VoidCallback? onComplete; // callback ketika task selesai

  const TaskWithTimer({
    super.key,
    required this.taskName,
    required this.taskDuration,
    this.onComplete,
  });

  @override
  State<TaskWithTimer> createState() => _TaskWithTimerState();
}

class _TaskWithTimerState extends State<TaskWithTimer> {
  late int remainingSeconds;
  Timer? timer;
  bool isRunning = false;
  bool isDone = false;

  String get currentImage {
  if (remainingSeconds == 0) {
    return 'assets/mascot.png';
  } else if (remainingSeconds <= (widget.taskDuration * 60) / 2) {
    return 'assets/hatching.png';
  } else {
    return 'assets/egg.png';
  }
}

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
        widget.onComplete?.call(); // panggil callback ketika selesai
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
                      icon: Image.asset(
                        'assets/icons/back.png',
                        width: 40,
                        height: 40,
                      ),
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
                      color: Color(0xFF3A2081),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Image.asset(
              currentImage,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 21),
            Text(
              "Timer",
              style: TextStyle(
                fontFamily: "PlusJakartaSans",
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Color(0xFF262626)
              ),
              ),
            const SizedBox(height: 4),
            Text(
              formatTime(remainingSeconds),
              style: const TextStyle(
                fontFamily: "PlusJakartaSans",
                fontSize: 20,
                fontWeight: FontWeight.w600,

              ),
            ),
            const SizedBox(height: 29),
            Container(
              width: 333,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3A2081),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
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
