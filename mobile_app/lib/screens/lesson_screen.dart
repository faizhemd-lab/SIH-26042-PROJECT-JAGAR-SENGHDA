import 'package:flutter/material.dart';
import '../services/pdf_generator.dart';

/// Interactive Micro-Lesson Activity Screen for Non-Native Primary Teachers
class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  // Stage 1: 80% L1 (Native Dialect) / 20% L2 (Hindi)
  // Stage 2: 50% L1 / 50% L2
  // Stage 3: 20% L1 / 80% L2
  int _selectedStage = 1;

  final List<Map<String, String>> _sampleVocab = [
    {'hindi': 'पानी', 'santhali': 'दाः', 'ol_chiki': 'ᱫᱟᱜ'},
    {'hindi': 'पेड़', 'santhali': 'दारᱮ', 'ol_chiki': 'ᱫᱟᱨᱮ'},
    {'hindi': 'फूल', 'santhali': 'बाहा', 'ol_chiki': 'ᱵᱟᱦᱟ'},
    {'hindi': 'गिनती', 'santhali': 'लेखा', 'ol_chiki': 'ᱞᱮᱠᱷᱟ'},
  ];

  void _exportPdfWorksheet() async {
    final file = await PdfGenerator.generateBilingualWorksheet(
      title: 'Foundational Numeracy & Vocabulary Activity',
      gradeLevel: 'Grade 1 (Stage $_selectedStage Scaffolding)',
      vocabularyList: _sampleVocab,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Off-Grid Vector PDF Exported to: ${file.path}'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedagogy & Lesson Canvas'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export Printable Worksheet',
            onPressed: _exportPdfWorksheet,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'L1 / L2 Blending Stage Ratio',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('Stage 1\n80% L1')),
                ButtonSegment(value: 2, label: Text('Stage 2\n50/50')),
                ButtonSegment(value: 3, label: Text('Stage 3\n80% L2')),
              ],
              selected: {_selectedStage},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _selectedStage = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Micro-Lesson Metaphor Adaptation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Target: NUM_G1_01',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        Chip(label: Text('Numeracy')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Standard Textbook: "Counting Traffic Lights"',
                      style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Icon(Icons.swap_horiz, color: Colors.teal),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tribal Belt Context: "महुआ के फूल गिनना" (Counting Mahua Flowers)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bilingual Vocabulary & Dual Script',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _sampleVocab.length,
                itemBuilder: (context, index) {
                  final item = _sampleVocab[index];
                  return Card(
                    child: ListTile(
                      title: Text('${item['hindi']} ↔ ${item['santhali']}'),
                      subtitle: Text('Ol Chiki Script: ${item['ol_chiki']}'),
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Text('${index + 1}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
