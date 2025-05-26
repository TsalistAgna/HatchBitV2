import 'package:flutter/material.dart';
import 'package:project_mobile/home_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                    controller: _titleController,
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
                    controller: _descriptionController,
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
                          _buildTimeDropdown("H", hours, 24, (value) {
                            setState(() => hours = value!);
                          }),
                          const Text(":", style: TextStyle(fontSize: 20)),
                          _buildTimeDropdown("M", minutes, 60, (value) {
                            setState(() => minutes = value!);
                          }),
                          const Text(":", style: TextStyle(fontSize: 20)),
                          _buildTimeDropdown("S", seconds, 60, (value) {
                            setState(() => seconds = value!);
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

  Widget _buildTimeDropdown(String label, int value, int max, ValueChanged<int?> onChanged) {
    return DropdownButton<int>(
      value: value,
      hint: Text(label),
      items: List.generate(max, (index) => DropdownMenuItem(
        value: index,
        child: Text('$index $label'),
      )),
      onChanged: onChanged,
      dropdownColor: Colors.deepPurple.shade50,
      borderRadius: BorderRadius.circular(8),
    );
  }

  Future<void> _saveHabit() async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    // Validasi input
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title cannot be empty")),
      );
      return;
    }

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be logged in to add habits")),
      );
      return;
    }

    // Validasi timer jika useTimer aktif
    if (useTimer && hours == 0 && minutes == 0 && seconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please set timer duration")),
      );
      return;
    }

    try {
      // Tampilkan loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Simpan ke Firestore
      await FirebaseFirestore.instance.collection('habits').add({
        'uid': user.uid,
        'title': title,
        'description': description,
        'useTimer': useTimer,
        'hours': hours,
        'minutes': minutes,
        'seconds': seconds,
        'durationInSeconds': hours * 3600 + minutes * 60 + seconds,
        'createdAt': Timestamp.now(),
        'isCompleted': false,
      });

      // Tutup loading indicator
      Navigator.pop(context);

      // Tampilkan dialog konfirmasi
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Habit created successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                _resetForm();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );

    } catch (e) {
      // Tutup loading indicator jika ada error
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add habit: ${e.toString()}")),
      );
      debugPrint("Error saving habit: $e");
    }
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      useTimer = false;
      hours = minutes = seconds = 0;
    });
  }
}