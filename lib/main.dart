import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/modular_session_screen.dart';

void main() {
  runApp(const YogaApp());
}

class YogaApp extends StatelessWidget {
  const YogaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modular Yoga App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomeScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/modular') {
          final fileName = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ModularSessionScreen(jsonFileName: fileName),
          );
        }
        return null;
      },
    );
  }
}
