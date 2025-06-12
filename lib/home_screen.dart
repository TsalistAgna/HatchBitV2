import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'addTask.dart';
import 'task_with_timer.dart';
import 'edit_profile.dart';
import 'setting.dart';
import 'profile.dart';
import 'about_us.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.deepPurple,
        onTap: (index) {
          if (index == 0) {
            // Stay on home
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddHabitPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.add, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 53, left: 13, right: 13),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('habits')
                  .where(
                    'uid',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                  )
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final habits = snapshot.data!.docs;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: "PlusJakartaSans",
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(text: "Hi, "),
                        TextSpan(
                          text: "Carmen",
                          style: TextStyle(color: Color(0xFF7B6AAB)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 100,
                    child: SfDateRangePicker(
                      onSelectionChanged: (args) {
                        setState(() {
                          selectedDate = args.value;
                        });
                      },
                      selectionMode: DateRangePickerSelectionMode.single,
                      initialSelectedDate: selectedDate,
                      view: DateRangePickerView.month,
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                        viewHeaderHeight: 60,
                        dayFormat: 'EEE',
                        numberOfWeeksInView: 1,
                        enableSwipeSelection: true,
                      ),
                      headerHeight: 0,
                      showNavigationArrow: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "To Do",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),

                  ...habits.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['title'] ?? '';
                    final desc = data['description'] ?? '';
                    final useTimer = data['useTimer'] ?? false;
                    final hours = data['hours'] ?? 0;
                    final minutes = data['minutes'] ?? 0;
                    final isCompleted = data['isCompleted'] ?? false;

                    return TaskCard(
                      taskName: "$title${useTimer ? " ($hours:$minutes)" : ""}",
                      isDone: isCompleted,
                      onTap: () {
                        if (useTimer) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => TaskWithTimer(
                                    taskName: title,
                                    taskDuration: (hours * 60) + minutes,
                                    onComplete: () {
                                      // Update completion status when timer finishes
                                      doc.reference.update({
                                        'isCompleted': true,
                                      });
                                    },
                                  ),
                            ),
                          );
                        } else {
                          // Toggle completion status for non-timer tasks
                          doc.reference.update({'isCompleted': !isCompleted});
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 45),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String taskName;
  final bool isDone;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.taskName,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isDone ? Colors.green.shade50 : Colors.deepPurple.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(
            taskName,
            style: TextStyle(
              decoration: isDone ? TextDecoration.lineThrough : null,
              color: isDone ? Colors.grey : Colors.black,
            ),
          ),
          trailing: Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? Colors.green : Colors.purple,
          ),
        ),
      ),
    );
  }
}
