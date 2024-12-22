import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'trivia_main_screen.dart';
import 'CongratScreen.dart';

class QuestionScreen extends StatefulWidget {
  final String topicName;

  const QuestionScreen({super.key, required this.topicName});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // Quiz variables
  int questionNo = 1;
  int score = 0;
  int currentQuestionIndex = 0;
  int limit = 10;

  // Timer variables
  late Timer quizTimer;
  int totalTimeInMin = 1;
  int seconds = 60;

  // Question and options
  List<Map<String, dynamic>> questions = [];
  String currentQuestion = '';
  List<String> currentOptions = ['', '', '', ''];
  String currentCorrectAnswer = '';

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    startTimer();
  }

  Future<void> fetchQuestions() async {
    try {
      // Normalize topic name
      String normalizedTopicName = widget.topicName.toLowerCase();

      // Replace specific topic names
      if (normalizedTopicName == 'database') {
        normalizedTopicName = 'db';
      } else if (normalizedTopicName == 'networking') {
        normalizedTopicName = 'dcn';
      } else if (normalizedTopicName == 'data structure') {
        normalizedTopicName = 'data_structure';
      }

      final ref = FirebaseDatabase.instance.ref('0').child('data');
      final snapshot = await ref.get();

      questions.clear();

      if (snapshot.exists) {
        final data = snapshot.value;

        if (data is Map) {
          // Process data if it's a Map
          questions = (data as Map<dynamic, dynamic>).entries
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
          }).toList();
        } else if (data is List) {
          // Process data if it's a List
          questions = data
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
          }).toList();
        } else {
          print('Unexpected data type: ${data.runtimeType}');
        }

        // Handle different scenarios based on topic
        if (normalizedTopicName.toLowerCase() == 'mix') {
          // Randomly select 10 questions from all categories
          questions.shuffle();
          questions = questions.take(10).toList();
        } else {
          // Filter questions by category
          questions = questions
              .where((question) =>
          question['category'].toString().toLowerCase() == normalizedTopicName)
              .toList();
        }

        // Shuffle questions and set first question
        questions.shuffle();

        if (questions.isNotEmpty) {
          setState(() {
            currentQuestion = questions[0]['question'];
            currentOptions = List<String>.from(questions[0]['options']);
            currentCorrectAnswer = questions[0]['correct_answer'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No questions found for ${widget.topicName}')),
          );
        }
      } else {
        print('No data found under "0/data".');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No data found for ${widget.topicName}')),
        );
      }
    } catch (e) {
      print('Error fetching questions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load questions: $e')),
      );
    }
  }

  void startTimer() {
    quizTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds == 0) {
          checkAnswer('');
        } else {
          seconds--;
        }
      });
    });
  }

  void checkAnswer(String selectedOption) {
    // Check if selected option matches correct answer
    if (selectedOption == currentCorrectAnswer) {
      score++;
    }

    // Move to next question
    currentQuestionIndex++;
    questionNo++;

    if (currentQuestionIndex < limit) {
      // Update current question and options
      setState(() {
        currentQuestion = questions[currentQuestionIndex]['question'];
        currentOptions = List<String>.from(questions[currentQuestionIndex]['options']);
        currentCorrectAnswer = questions[currentQuestionIndex]['correct_answer'];
        seconds = 60;
      });
    } else {
      // All questions answered
      navigateToCongratsScreen();
    }
  }

  void navigateToCongratsScreen() {
    quizTimer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CongratScreen(score: score), // Navigate to CongratsScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF3F6),
      body: SafeArea(
        child: questions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Timer Container with Enhanced Styling
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06D3F6),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.topicName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.timer_outlined,
                        color: Colors.black,
                        size: 30.0,
                      ),
                      const SizedBox(width: 7.0),
                      Text(
                        '$seconds s',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontFamily: 'sans-serif-medium',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                Row(
                  children: [
                    const Text(
                      'Question',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$questionNo'.padLeft(2, '0'),
                      style: const TextStyle(
                        color: Color(0xFF50a7c2),
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        currentQuestion,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ElevatedButton(
                        onPressed: () => checkAnswer(currentOptions[index]),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: const Color(0xFFCCD2D6),
                          foregroundColor: const Color(0xFF17A5E8),
                        ),
                        child: Text(
                          currentOptions[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 70.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quit Quiz with Enhanced Styling
                    GestureDetector(
                      onTap: () {
                        quizTimer.cancel();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TriviaMainScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.only(left: 100.0),
                        decoration: BoxDecoration(
                          color: Color(0xFF17A5E8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.power_settings_new,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            const SizedBox(width: 5.0),
                            const Text(
                              'Quit Quiz',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    quizTimer.cancel();
    super.dispose();
  }
}
