import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationPage extends StatelessWidget {
	final String name;
	final String course;
	final String section;
	final String subject1;
	final String time1;
	final String subject2;
	final String time2;

	const VerificationPage({
		super.key,
		this.name = '',
		this.course = '',
		this.section = '',
		this.subject1 = '',
		this.time1 = '',
		this.subject2 = '',
		this.time2 = '',
	});

	Future<void> saveVerification(BuildContext context) async {
		try {
			final regRef = FirebaseFirestore.instance.collection('registrations');

			final doc = {
				'name': name,
				'course': course,
				'section': section,
				'subject1': subject1,
				'time1': time1,
				'subject2': subject2,
				'time2': time2,
				'createdAt': FieldValue.serverTimestamp(),
			};

			await regRef.add(doc);

			ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data saved to Firestore')));
			Navigator.popUntil(context, (route) => route.isFirst);
		} catch (e) {
			ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save data: $e')));
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Verification'),
				actions: [
					IconButton(
						icon: const Icon(Icons.list),
						onPressed: () {
							Navigator.push(
								context,
								MaterialPageRoute(builder: (_) => const VerificationsResultsPage()),
							);
						},
					),
				],
			),
			body: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text('Name: $name'),
						Text('Course: $course'),
						Text('Section: $section'),
						const SizedBox(height: 25),
						const Text('Subjects:'),
						Text('1) $subject1 — $time1'),
						Text('2) $subject2 — $time2'),
						const SizedBox(height: 44),
						Row(
							children: [
								ElevatedButton(
									onPressed: () => saveVerification(context),
									child: const Text('Confirm & Save'),
								),
								const SizedBox(width: 20),
								ElevatedButton(
									onPressed: () => Navigator.pop(context),
									child: const Text('Back'),
								),
							],
						),
					],
				),
			),
		);
	}
}

class VerificationsResultsPage extends StatelessWidget {
  const VerificationsResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance.collection('verifications').orderBy('createdAt', descending: true).snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Verifications')),
			// add a button to view registrations as well
			floatingActionButton: FloatingActionButton(
				child: const Icon(Icons.storage),
				onPressed: () {
					Navigator.push(
						context,
						MaterialPageRoute(builder: (_) => const RegistrationsResultsPage()),
					);
				},
			),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading verifications'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('No verifications yet'));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((data['name'] ?? '').toString().isNotEmpty)
                        Text('Name: ${data['name']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      if ((data['course'] ?? '').toString().isNotEmpty)
                        Text('Course: ${data['course']}', style: const TextStyle(fontSize: 18)),
                      if ((data['section'] ?? '').toString().isNotEmpty)
                        Text('Section: ${data['section']}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Subject 1: ${data['subject1'] ?? ''}', style: const TextStyle(fontSize: 18)),
                      Text('Time 1: ${data['time1'] ?? ''}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 6),
                      Text('Subject 2: ${data['subject2'] ?? ''}', style: const TextStyle(fontSize: 18)),
                      Text('Time 2: ${data['time2'] ?? ''}', style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RegistrationsResultsPage extends StatelessWidget {
	const RegistrationsResultsPage({super.key});

	@override
	Widget build(BuildContext context) {
		final stream = FirebaseFirestore.instance.collection('registrations').orderBy('createdAt', descending: true).snapshots();

		return Scaffold(
			appBar: AppBar(title: const Text('Registrations')),
			body: StreamBuilder<QuerySnapshot>(
				stream: stream,
				builder: (context, snapshot) {
					if (snapshot.hasError) return const Center(child: Text('Error loading registrations'));
					if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

					final docs = snapshot.data?.docs ?? [];
					if (docs.isEmpty) return const Center(child: Text('No registrations yet'));

					return ListView.builder(
						padding: const EdgeInsets.all(12),
						itemCount: docs.length,
						itemBuilder: (context, index) {
							final data = docs[index].data() as Map<String, dynamic>;
							return Card(
								margin: const EdgeInsets.symmetric(vertical: 8),
								child: Padding(
									padding: const EdgeInsets.all(16),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											if ((data['name'] ?? '').toString().isNotEmpty)
												Text('Name: ${data['name']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
											if ((data['course'] ?? '').toString().isNotEmpty)
												Text('Course: ${data['course']}', style: const TextStyle(fontSize: 18)),
											if ((data['section'] ?? '').toString().isNotEmpty)
												Text('Section: ${data['section']}', style: const TextStyle(fontSize: 18)),
											const SizedBox(height: 8),
											Text('Subject 1: ${data['subject1'] ?? ''}', style: const TextStyle(fontSize: 18)),
											Text('Time 1: ${data['time1'] ?? ''}', style: const TextStyle(fontSize: 18)),
											const SizedBox(height: 6),
											Text('Subject 2: ${data['subject2'] ?? ''}', style: const TextStyle(fontSize: 18)),
											Text('Time 2: ${data['time2'] ?? ''}', style: const TextStyle(fontSize: 18)),
										],
									),
								),
							);
						},
					);
				},
			),
		);
	}
}