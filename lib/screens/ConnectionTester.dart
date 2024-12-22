import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ConnectionTester extends StatefulWidget {
  const ConnectionTester({super.key});

  @override
  _ConnectionTesterState createState() => _ConnectionTesterState();
}

class _ConnectionTesterState extends State<ConnectionTester> {
  // List of categories to test
  final List<String> categoriesToTest = [
    'Android',
    'dcn',
    'ai',
    // Add more categories as needed
  ];

  // Selected category
  String selectedCategory = 'Android';

  // Questions fetched from Firebase
  List<Map<dynamic, dynamic>> fetchedQuestions = [];

  // Connection status
  bool isConnected = false;
  String connectionStatus = 'Checking connection...';

  @override
  void initState() {
    super.initState();
    testFirebaseConnection();
  }

  Future<void> testFirebaseConnection() async {
    try {
      // Initialize Firebase if not already initialized
      await Firebase.initializeApp();

      // Test database reference
      final ref = FirebaseDatabase.instance.ref("0").child("data");

      print(ref);
      // Check connection
      final snapshot = await ref.get();

      setState(() {
        isConnected = true;
        connectionStatus = 'Connected to Firebase Realtime Database';
      });
    } catch (e) {
      setState(() {
        isConnected = false;
        connectionStatus = 'Connection Failed: $e';
      });
    }
  }

  Future<void> fetchQuestionsFromNestedData() async {
    try {
      // Reference to the "0/data" node
      final ref = FirebaseDatabase.instance.ref('0').child('data');

      // Fetch the data
      final snapshot = await ref.get();

      // Clear the previous questions
      setState(() {
        fetchedQuestions.clear();
      });

      if (snapshot.exists) {
        final data = snapshot.value;

        if (data is Map) {
          // Process data if it's a Map
          setState(() {
            fetchedQuestions = (data as Map<dynamic, dynamic>).entries
                .map((entry) {
              final questionData = entry.value as Map<dynamic, dynamic>;
              return {
                'question': questionData['Question'],
                'options': [
                  questionData['A'],
                  questionData['B'],
                  questionData['C'],
                  questionData['D'],
                ],
                'correct_answer': questionData['ANSWER'],
                'category': questionData['categories'] ?? 'Uncategorized',
              };
            })
                .where((question) =>
            question['category'].toString().toLowerCase() ==
                selectedCategory.toLowerCase())
                .toList();
          });
        } else if (data is List) {
          // Process data if it's a List
          setState(() {
            fetchedQuestions = data
                .map((item) {
              final questionData = item as Map<dynamic, dynamic>;
              return {
                'question': questionData['Question'],
                'options': [
                  questionData['A'],
                  questionData['B'],
                  questionData['C'],
                  questionData['D'],
                ],
                'correct_answer': questionData['ANSWER'],
                'category': questionData['categories'] ?? 'Uncategorized',
              };
            })
                .where((question) =>
            question['category'].toString().toLowerCase() ==
                selectedCategory.toLowerCase())
                .toList();
          });
        } else {
          print('Unexpected data type: ${data.runtimeType}');
        }
      } else {
        print('No data found under "0/data".');
      }
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Connection Tester'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection Status
            Text(
              connectionStatus,
              style: TextStyle(
                color: isConnected ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Select Category',
                border: OutlineInputBorder(),
              ),
              items: categoriesToTest
                  .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Fetch Questions Button
            ElevatedButton(
              onPressed: isConnected ? fetchQuestionsFromNestedData : null,
              child: const Text('Fetch Questions'),
            ),

            const SizedBox(height: 20),
            Text(
              'Fetched Questions: ${fetchedQuestions.length}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Display fetched questions
            Expanded(
              child: ListView.builder(
                itemCount: fetchedQuestions.length,
                itemBuilder: (context, index) {
                  final question = fetchedQuestions[index];
                  return Card(
                    child: ListTile(
                      title: Text(question['question']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...question['options'].map<Widget>((option) => Text(option)).toList(),
                          Text('Answer: ${question['correct_answer']}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Category: ${question['category']}'),
                        ],
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
