import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/trivia_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCnAfHag4XVzzWLishiaYTFi1IPAPhhbqA",
          appId: "1:83891236587:android:b6222eb6269afd7a7f18ae",
          messagingSenderId: "83891236587",
          projectId: "triviagame-5bb67",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trivia App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Add any additional app-wide theme configurations
      ),
      home: const TriviaMainScreen(),
    );
  }
}