import 'package:flutter/material.dart';
import 'verification.dart';

class SubjectEnrollmentPage extends StatefulWidget {
  final String? name;
  final String? course;
  final String? section;

  const SubjectEnrollmentPage({super.key, this.name, this.course, this.section});

  @override
  State<SubjectEnrollmentPage> createState() => _SubjectEnrollmentPageState();
}

class _SubjectEnrollmentPageState extends State<SubjectEnrollmentPage> {
  final TextEditingController subject1Controller = TextEditingController();
  final TextEditingController time1Controller = TextEditingController();
  final TextEditingController subject2Controller = TextEditingController();
  final TextEditingController time2Controller = TextEditingController();

  bool validateEnrollment() {
    if (subject1Controller.text.trim().isEmpty ||
        time1Controller.text.trim().isEmpty ||
        subject2Controller.text.trim().isEmpty ||
        time2Controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    subject1Controller.dispose();
    time1Controller.dispose();
    subject2Controller.dispose();
    time2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subject Enrollment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: subject1Controller,
              decoration: const InputDecoration(
                labelText: 'Subject 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: time1Controller,
              decoration: const InputDecoration(
                labelText: 'Time 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: subject2Controller,
              decoration: const InputDecoration(
                labelText: 'Subject 2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: time2Controller,
              decoration: const InputDecoration(
                labelText: 'Time 2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!validateEnrollment()) return;

                      final name = widget.name ?? '';
                      final course = widget.course ?? '';
                      final section = widget.section ?? '';
                      final subject1 = subject1Controller.text.trim();
                      final time1 = time1Controller.text.trim();
                      final subject2 = subject2Controller.text.trim();
                      final time2 = time2Controller.text.trim();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerificationPage(
                            name: name,
                            course: course,
                            section: section,
                            subject1: subject1,
                            time1: time1,
                            subject2: subject2,
                            time2: time2,
                          ),
                        ),
                      );
                    },
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

