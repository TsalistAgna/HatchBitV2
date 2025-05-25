import 'package:flutter/material.dart';
import 'package:project_mobile/home_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MaterialApp(
    home: AddHabitPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  bool useTimer = false;
  int hours = 0, minutes = 0, seconds = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        backgroundColor: Colors.white,
        color: Colors.deepPurple,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else if (index == 1) {
            // Stay on AddHabitPage
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
        title: const Text('Create New Habit', style: TextStyle(color: Colors.deepPurple)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Title"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _titleController, // Tambah controller
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.deepPurple.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text("Description"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _descriptionController, // Tambah controller
                    maxLines: 2,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.deepPurple.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Switch(
                        value: useTimer,
                        onChanged: (value) {
                          setState(() {
                            useTimer = value;
                          });
                        },
                        activeColor: Colors.deepPurple,
                      ),
                      const Text("Use Timer?"),
                    ],
                  ),
                  if (useTimer)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTimeField("HH", (val) {
                            setState(() => hours = int.tryParse(val) ?? 0);
                          }),
                          const Text(":", style: TextStyle(fontSize: 20)),
                          _buildTimeField("MM", (val) {
                            setState(() => minutes = int.tryParse(val) ?? 0);
                          }),
                          const Text(":", style: TextStyle(fontSize: 20)),
                          _buildTimeField("SS", (val) {
                            setState(() => seconds = int.tryParse(val) ?? 0);
                          }),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveHabit,
                child: const Text("CREATE", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField(String hint, Function(String) onChanged) {
    return SizedBox(
      width: 60,
      child: TextField(
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.deepPurple.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> _saveHabit() async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    int totalSeconds = hours * 3600 + minutes * 60 + seconds;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title cannot be empty")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('habits').add({
        'title': title,
        'description': description,
        'useTimer': useTimer,
        'durationInSeconds': useTimer ? totalSeconds : 0,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Habit added successfully!")),
      );

      // Optional: Clear fields
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        useTimer = false;
        hours = minutes = seconds = 0;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add habit")),
      );
    }
  }
}