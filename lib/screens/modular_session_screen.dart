import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/modular_pose_model.dart';
import '../services/modular_json_loader.dart';

class ModularSessionScreen extends StatefulWidget {
  final String jsonFileName;

  const ModularSessionScreen({super.key, required this.jsonFileName});

  @override
  State<ModularSessionScreen> createState() => _ModularSessionScreenState();
}

class _ModularSessionScreenState extends State<ModularSessionScreen> {
  ModularFlow? flow;
  int currentSegmentIndex = 0;
  int loopCountRemaining = 0;
  String currentText = "";
  String currentImage = "";
  int elapsed = 0;
  bool isPaused = false;
  bool sessionComplete = false;

  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer bgPlayer = AudioPlayer();
  late StreamSubscription<Duration> _positionSubscription;

  @override
  void initState() {
    super.initState();
    playBackgroundMusic();
    loadFlow();
  }

  Future<void> playBackgroundMusic() async {
    try {
      await bgPlayer.setReleaseMode(ReleaseMode.loop);
      await bgPlayer.setVolume(0.3);
      await bgPlayer.play(AssetSource('audio/bg_music.mp3'));
    } catch (e) {
      print("❌ Failed to play background music: $e");
    }
  }

  Future<void> loadFlow() async {
    flow = await ModularJSONLoader.loadFlow(widget.jsonFileName);

    setState(() {
      loopCountRemaining = flow!.metadata.defaultLoopCount;
    });

    playSegment(flow!.sequence[currentSegmentIndex]);
  }

  void playSegment(Sequence segment) async {
    await audioPlayer.stop();
    await audioPlayer.play(
      AssetSource('audio/${flow!.assets.audio[segment.audioRef]}'),
    );

    elapsed = 0;
    isPaused = false;
    sessionComplete = false;

    _positionSubscription = audioPlayer.onPositionChanged.listen((position) {
      if (!isPaused) {
        final elapsedSeconds = position.inSeconds;

        if (elapsedSeconds >= segment.durationSec) {
          _positionSubscription.cancel();
          nextSegment();
        } else {
          updateScriptByTime(segment, elapsedSeconds);
          setState(() {
            elapsed = elapsedSeconds;
          });
        }
      }
    });
  }

  void updateScriptByTime(Sequence segment, int elapsed) {
    for (final script in segment.script) {
      if (elapsed >= script.startSec && elapsed < script.endSec) {
        if (script.text != currentText || script.imageRef != currentImage) {
          setState(() {
            currentText = script.text;
            currentImage = flow!.assets.images[script.imageRef]!;
          });
        }
        break;
      }
    }
  }

  void nextSegment() {
    final current = flow!.sequence[currentSegmentIndex];

    if (current.type == 'loop' && loopCountRemaining > 1) {
      loopCountRemaining--;
      playSegment(current); // repeat loop
    } else {
      currentSegmentIndex++;

      if (currentSegmentIndex >= flow!.sequence.length) {
        showCompleteScreen();
        return;
      }

      final next = flow!.sequence[currentSegmentIndex];
      if (next.type == 'loop') {
        loopCountRemaining = next.iterations ?? flow!.metadata.defaultLoopCount;
      }

      playSegment(next);
    }
  }

  void togglePause() async {
    setState(() {
      isPaused = !isPaused;
    });

    if (isPaused) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.resume();
    }
  }

  void restartSession() {
    setState(() {
      currentSegmentIndex = 0;
      loopCountRemaining = flow!.metadata.defaultLoopCount;
      currentText = "";
      currentImage = "";
      elapsed = 0;
      sessionComplete = false;
    });
    playSegment(flow!.sequence[0]);
  }

  Future<void> showCompleteScreen() async {
    setState(() {
      sessionComplete = true;
      currentText = "Session Complete ✯";
      currentImage = flow!.assets.images.values.first;
    });

    final prefs = await SharedPreferences.getInstance();
    int streak = prefs.getInt('streak') ?? 0;
    await prefs.setInt('streak', streak + 1);
  }

  Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', 0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Streak reset to 0")),
    );
  }

  Future<void> viewStreak() async {
    final prefs = await SharedPreferences.getInstance();
    int streak = prefs.getInt('streak') ?? 0;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Your Streak"),
        content: Text("You've completed $streak session${streak == 1 ? '' : 's'}!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          TextButton(
            onPressed: () {
              resetStreak();
              Navigator.pop(context);
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    audioPlayer.dispose();
    bgPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (flow == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentSegment = flow!.sequence[currentSegmentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F7),
      appBar: AppBar(
        title: Text(flow!.metadata.title),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: viewStreak,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: sessionComplete
              ? Column(
                  key: const ValueKey('complete'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, size: 80, color: Colors.teal),
                    const SizedBox(height: 20),
                    Text(
                      currentText,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: restartSession,
                      icon: const Icon(Icons.replay),
                      label: const Text("Restart Session"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (currentImage.isNotEmpty)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: ClipRRect(
                          key: ValueKey(currentImage),
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/$currentImage',
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),
                    Text(
                      currentText,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ...currentSegment.script.map((script) {
                      final isActive = elapsed >= script.startSec && elapsed < script.endSec;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          script.text,
                          style: TextStyle(
                            fontSize: 14,
                            color: isActive ? Colors.teal : Colors.grey,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: currentSegment.durationSec == 0
                          ? 0
                          : elapsed / currentSegment.durationSec,
                      backgroundColor: Colors.grey[300],
                      color: Colors.teal,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Time: $elapsed sec",
                      style: const TextStyle(color: Colors.teal),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: togglePause,
                      icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                      label: Text(isPaused ? 'Resume' : 'Pause'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
