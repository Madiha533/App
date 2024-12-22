import 'package:flutter/material.dart';
import 'ModeSelection.dart'; // Ensure this import is correct

class TriviaMainScreen extends StatelessWidget {
  const TriviaMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // This will close the app when back button is pressed
        return true; // Returning true allows the back action to proceed
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEDF3F6),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Top Header Section
              Stack(
                children: [
                  Container(
                    height: 230,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2A2B31),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/quizimg.png',
                            width: 210,
                            fit: BoxFit.cover,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Start with \nTrivia app',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Pakistan\'s first app for the Students',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Top Quiz Categories Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Top Quiz Categories',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD5F0F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: Color(0xFF06D2F6),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Quiz Categories
              _buildQuizCategories(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCategories(BuildContext context) {
    final categories = [
      {'id': 'CODING', 'icon': 'coding', 'title': 'Coding'},
      {'id': 'ANDROID', 'icon': 'android_studio', 'title': 'Android'},
      {'id': 'OOP', 'icon': 'pyhton', 'title': 'OOP'},
      {'id': 'DATABASE', 'icon': 'database', 'title': 'Database'},
      {'id': 'AI', 'icon': 'ai', 'title': 'AI'},
      {'id': 'NETWORKING', 'icon': 'networking', 'title': 'Networking'},
      {'id': 'WEB', 'icon': 'web', 'title': 'Web'},
      {'id': 'DATA_STRUCTURE', 'icon': 'ds', 'title': 'Data Structure'},
      {'id': 'OS', 'icon': 'os', 'title': 'OS'},
      {'id': 'MIX', 'icon': 'random', 'title': 'Mix'},
    ];

    return Column(
      children: [
        for (int i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categories
                  .skip(i * 3)
                  .take(3)
                  .map((category) => _buildCategoryCard(context, category))
                  .toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCategoryCard(context, categories.last),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, String> category) {
    return GestureDetector(
      onTap: () {
        // Navigate to ModeSelectionScreen and pass the selected topic
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModeSelectionScreen(
              selectedTopic: category['title']!,
            ),
          ),
        );
      },
      child: Container(
        width: 125,
        height: 130,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/${category['icon']}.png',
              width: 70,
              height: 70,
            ),
            const SizedBox(height: 8),
            Text(
              category['title']!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'sans-serif-medium',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
