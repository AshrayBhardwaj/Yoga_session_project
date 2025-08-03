import 'package:flutter/material.dart';
import '../models/pose_model.dart';
import '../services/json_loader.dart';
import 'session_screen.dart';

class PosePreviewScreen extends StatefulWidget {
  const PosePreviewScreen({super.key});

  @override
  _PosePreviewScreenState createState() => _PosePreviewScreenState();
}

class _PosePreviewScreenState extends State<PosePreviewScreen> {
  List<Pose> poses = [];

  @override
  void initState() {
    super.initState();
    loadPoses();
  }

  Future<void> loadPoses() async {
    final loadedPoses = await JSONLoader.loadPoses();
    setState(() {
      poses = loadedPoses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3F7),
      appBar: AppBar(
        title: Text('Yoga Poses'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: poses.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: poses.length,
              itemBuilder: (context, index) {
                final pose = poses[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/${pose.imagePath}',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      pose.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(context, '/modular');
      },
      icon: Icon(Icons.auto_awesome),
      label: Text('Cat-Cow Flow'),
      backgroundColor: Colors.teal,
    ),
    SizedBox(height: 12),
    FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionScreen(poses: poses),
          ),
        );
      },
      backgroundColor: Colors.teal,
      child: Icon(Icons.play_arrow),
    ),
  ],
),

    );
  }
}
