import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/pose_model.dart';

class SessionScreen extends StatefulWidget {
  final List<Pose> poses;
  const SessionScreen({super.key, required this.poses});

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  int currentIndex = 0;
  late AudioPlayer _audioPlayer;
  Timer? _timer;
  bool isPaused = false;
  int secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    startPose();
  }

  void startPose() async {
    if (currentIndex >= widget.poses.length) return;

    Pose currentPose = widget.poses[currentIndex];
    await _audioPlayer.play(AssetSource('audio/${currentPose.audioPath}'));
    setState(() {
      secondsLeft = currentPose.duration;
      isPaused = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isPaused) {
        if (secondsLeft > 0) {
          setState(() {
            secondsLeft--;
          });
        } else {
          timer.cancel();
          _audioPlayer.stop();
          setState(() {
            currentIndex++;
          });
          startPose();
        }
      }
    });
  }

  void togglePause() async {
    setState(() {
      isPaused = !isPaused;
    });

    if (isPaused) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= widget.poses.length) {
      return Scaffold(
        appBar: AppBar(title: Text('Session Complete'), backgroundColor: Colors.teal),
        body: Center(
          child: Text(
            '🎉 You have completed the session!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    Pose currentPose = widget.poses[currentIndex];

    return Scaffold(
      backgroundColor: Color(0xFFF4F3F7),
      appBar: AppBar(
        title: Text('Yoga Session'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          SizedBox(
  height: 400,
  child: Image.asset(
    'assets/images/${currentPose.imagePath}',
    fit: BoxFit.contain,
    width: double.infinity,
  ),
),


            SizedBox(height: 30),
            Text(
              currentPose.name,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Hold for ${currentPose.duration} seconds',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(
              value: secondsLeft / currentPose.duration,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              strokeWidth: 6,
            ),
            SizedBox(height: 10),
            Text(
              '$secondsLeft sec left',
              style: TextStyle(fontSize: 18, color: Colors.teal),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: togglePause,
              icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
              label: Text(isPaused ? 'Resume' : 'Pause'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
