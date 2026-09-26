import 'package:flutter/material.dart';

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.record_voice_over, size: 64, color: Colors.teal),
            const SizedBox(height: 16),
            const Text(
              'Offline Vernacular Pedagogy Assistant',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Target RAM Footprint: ≤ 550MB / 2GB',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
