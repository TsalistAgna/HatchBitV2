import 'package:flutter/material.dart';
import 'package:project_mobile/home_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
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
          },
        ),
        title: const Text(
          'Create New Habit',
          style: TextStyle(color: Colors.deepPurple),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Title"),
            const SizedBox(height: 5),
            TextField(
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
              Row(
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
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Implement create logic
                },
                child: const Text(
                  "CREATE",
                  style: TextStyle(color: Colors.white),
                  ),
              ),
            ),
          ],
        ),
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
}