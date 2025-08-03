import 'package:flutter/material.dart';
import '../widgets/session_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modular Yoga App', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 77, 7, 55),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/yoga_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SessionCard(
                  title: 'Cat-Cow Flow',
                  jsonFile: 'catcow.json',
                  description: 'Spinal mobility sequence to warm up the spine.',
                ),
                SessionCard(
                  title: 'Full Body Flow',
                  jsonFile: 'poses_converted.json',
                  description: 'Beginner-friendly flow for overall flexibility.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
