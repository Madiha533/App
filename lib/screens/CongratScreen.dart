import 'package:flutter/material.dart';
import 'package:app/screens/trivia_main_screen.dart';

class CongratScreen extends StatefulWidget {
  final int score;

  CongratScreen({required this.score});

  @override
  _CongratScreenState createState() => _CongratScreenState();
}

class _CongratScreenState extends State<CongratScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLowScore = widget.score <= 6;

    return Scaffold(
      body: Stack(
        children: [
          // Confetti animation
          if (!isLowScore)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  top: MediaQuery.of(context).size.height * _animation.value,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      'assets/confetti.gif',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          // Main content
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 10.0),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30.0),
                  Image.asset(
                    isLowScore ? 'assets/SadEmoji.png' : 'assets/trophy.png',
                    height: 345.0,
                  ),
                  Text(
                    isLowScore ? 'Please try again' : 'Congratulations!',
                    style: TextStyle(
                      color: Color(0xFFFDBB2D),
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!isLowScore)
                    Text(
                      'You break all the previous\nrecords.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  SizedBox(height: 20.0),
                  Text(
                    'YOUR SCORE',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFF10C69A),
                      letterSpacing: 0.5,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Color(0xFFFDBB2D),
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.score}',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: isLowScore ? Colors.red : Color(0xFF10C69A),
                          ),
                        ),
                        Text(
                          ' / 10',
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TriviaMainScreen()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.all(20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      textStyle:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    child: Text(
                      'Take New',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
