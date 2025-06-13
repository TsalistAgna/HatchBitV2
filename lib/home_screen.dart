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
  String username = '';

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  void getUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          username = doc.data()?['username'] ?? '';
        });
      }
    }
  }


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

            final selectedDateOnly = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
            );

            final filteredHabits = habits.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final Timestamp timestamp = data['createdAt'];
              final docDate = timestamp.toDate();
              final docDateOnly = DateTime(docDate.year, docDate.month, docDate.day);
              final isCompleted = data['isCompleted'] ?? false;

              return !isCompleted || docDateOnly == selectedDateOnly;
            }).toList();

            final incompleteHabits = filteredHabits.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return !(data['isCompleted'] ?? false);
            }).toList();

            final completedHabits = filteredHabits.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return (data['isCompleted'] ?? false);
            }).toList();


            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: "PlusJakartaSans",
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        const TextSpan(text: "Hi, "),
                        TextSpan(
                          text: username.isNotEmpty ? username : '...',
                          style: const TextStyle(color: Color(0xFF7B6AAB)),
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

                  // task belum selesai
                  const Text(
                    "To Do",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  ...incompleteHabits.map((doc) {
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
                              builder: (context) => TaskWithTimer(
                                taskName: title,
                                taskDuration: (hours * 60) + minutes,
                                onComplete: () {
                                  doc.reference.update({'isCompleted': true});
                                },
                              ),
                            ),
                          );
                        } else {
                          doc.reference.update({'isCompleted': !isCompleted});
                        }
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Hapus Task"),
                            content: const Text("Yakin ingin menghapus task ini?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  doc.reference.delete();
                                  Navigator.pop(context);
                                },
                                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),

                  const SizedBox(height: 30),

                  // task selesai
                  const Text(
                    "Completed",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  ...completedHabits.map((doc) {
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
                        if (!useTimer) {
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
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.taskName,
    required this.isDone,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDone ? Colors.green.shade50 : Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(
          taskName,
          style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? Colors.grey : Colors.black,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
            IconButton(
              icon: Icon(
                isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isDone ? Colors.green : Colors.purple,
              ),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}