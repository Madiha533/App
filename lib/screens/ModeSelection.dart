import 'package:flutter/material.dart';
import 'EasyMode.dart'; // Update with your actual import path
import 'QuestionScreen.dart'; // Update with your actual import path
import 'package:app/screens/ConnectionTester.dart';
class ModeSelectionScreen extends StatelessWidget {
  final String selectedTopic; // The selected topic passed from the previous screen

  const ModeSelectionScreen({super.key, required this.selectedTopic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Section
            Container(
              margin: const EdgeInsets.only(top: 70),
              width: double.infinity,
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/selection.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Title Section
            const SizedBox(height: 20),
            const Text(
              'SELECT MODE',
              style: TextStyle(
                color: Color(0xFFFFC100),
                fontFamily: 'sans-serif-medium',
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            // Button Section
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Easy Mode Button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to full EasyScreenMode with actual quiz logic
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EasyMode(
                            topicName: selectedTopic,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF6F86D6), width: 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Easy mode',
                          style: TextStyle(
                            color: Color(0xFF6F86D6),
                            fontSize: 20,
                            fontFamily: 'sans-serif-medium',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Difficult Mode Button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to full EasyScreenMode with actual quiz logic
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(
                            topicName: selectedTopic,
                          ),
                          // builder: (context) => ConnectionTester(),
                        ),
                      );
                    },
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFEF8E38), width: 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Difficult mode',
                          style: TextStyle(
                            color: Color(0xFFEF8E38),
                            fontSize: 20,
                            fontFamily: 'sans-serif-medium',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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