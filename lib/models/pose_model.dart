class Pose {
  final String name;
  final String imagePath;
  final String audioPath;
  final int duration;

  Pose({
    required this.name,
    required this.imagePath,
    required this.audioPath,
    required this.duration,
  });

  factory Pose.fromJson(Map<String, dynamic> json) {
    return Pose(
      name: json['pose_name'],
      imagePath: json['image_path'],
      audioPath: json['audio_path'],
      duration: json['duration'],
    );
  }
}
