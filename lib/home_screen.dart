import 'package:flutter/material.dart';
import 'package:project_mobile/addTask.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'task_with_timer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  final List<String> todoTasks = ['No Snack', 'Read a Book - 30 Mins'];
  final List<String> doneTasks = ['Wake Up at 5 AM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.deepPurple,
        onTap: (index) {
          if (index == 0) {
            // Navigate to home screen
          } else if (index == 1) {
            // Navigate to add task screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddHabitPage()),
            );
          } else if (index == 2) {
            // Navigate to profile screen
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
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hi Carmen
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

        // Calendar
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
        const Text("To Do",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),

        // To Do tasks
        ...todoTasks.map((task) {
          return TaskCard(
            taskName: task,
            isDone: true,
            onTap: task == 'Read a Book - 30 Mins'
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TaskWithTimer(
                          taskName: "Read A Book",
                          taskDuration: 30,
                        ),
                      ),
                    );
                  }
                : null,
          );
        }),

        const SizedBox(height: 45),
        const Text("Done",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),

        // Done tasks
        ...doneTasks.map((task) => TaskCard(taskName: task, isDone: false)),
        const SizedBox(height: 45),
      ],
    ),
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
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: Card(
        color: Colors.deepPurple.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(taskName),
          trailing: isDone
              ? const Icon(Icons.check, color: Colors.purple)
              : const Icon(Icons.close, color: Colors.purple),
        ),
      ),
    );
  }
}

