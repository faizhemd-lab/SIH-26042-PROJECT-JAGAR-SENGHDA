import 'package:flutter/material.dart';
import 'screens/dictionary_screen.dart';
import 'screens/lesson_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JagarSenghdaApp());
}

class JagarSenghdaApp extends StatelessWidget {
  const JagarSenghdaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Jagar Senghda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jagar Senghda | Vernacular Engine'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 72, color: Colors.teal),
              const SizedBox(height: 16),
              const Text(
                'Offline Vernacular Pedagogy Assistant',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Target Memory Footprint: ≤ 550MB / 2GB',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              
              // Action 1: Launch Vernacular Dictionary
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.menu_book),
                  label: const Text(
                    'Open Vernacular Dictionary',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DictionaryScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Action 2: Launch Pedagogical Lesson Canvas & PDF Compiler
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.teal, width: 2),
                  ),
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text(
                    'Open Pedagogical Lesson Canvas',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LessonScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
