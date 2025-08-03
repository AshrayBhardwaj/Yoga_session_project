class ModularFlow {
  final Metadata metadata;
  final Assets assets;
  final List<Sequence> sequence;

  ModularFlow({required this.metadata, required this.assets, required this.sequence});

  factory ModularFlow.fromJson(Map<String, dynamic> json) {
    return ModularFlow(
      metadata: Metadata.fromJson(json['metadata']),
      assets: Assets.fromJson(json['assets']),
      sequence: (json['sequence'] as List).map((e) => Sequence.fromJson(e)).toList(),
    );
  }
}

class Metadata {
  final String id;
  final String title;
  final String category;
  final int defaultLoopCount;
  final String tempo;

  Metadata({required this.id, required this.title, required this.category, required this.defaultLoopCount, required this.tempo});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      defaultLoopCount: json['defaultLoopCount'],
      tempo: json['tempo'],
    );
  }
}

class Assets {
  final Map<String, String> images;
  final Map<String, String> audio;

  Assets({required this.images, required this.audio});

  factory Assets.fromJson(Map<String, dynamic> json) {
    return Assets(
      images: Map<String, String>.from(json['images']),
      audio: Map<String, String>.from(json['audio']),
    );
  }
}

class Sequence {
  final String type;
  final String name;
  final String audioRef;
  final int durationSec;
  final int? iterations;
  final bool? loopable;
  final List<Script> script;

  Sequence({required this.type, required this.name, required this.audioRef, required this.durationSec, this.iterations, this.loopable, required this.script});

  factory Sequence.fromJson(Map<String, dynamic> json) {
    return Sequence(
      type: json['type'],
      name: json['name'],
      audioRef: json['audioRef'],
      durationSec: json['durationSec'],
      iterations: json['iterations'] == "{{loopCount}}" ? null : json['iterations'],
      loopable: json['loopable'],
      script: (json['script'] as List).map((e) => Script.fromJson(e)).toList(),
    );
  }
}

class Script {
  final String text;
  final int startSec;
  final int endSec;
  final String imageRef;

  Script({required this.text, required this.startSec, required this.endSec, required this.imageRef});

  factory Script.fromJson(Map<String, dynamic> json) {
    return Script(
      text: json['text'],
      startSec: json['startSec'],
      endSec: json['endSec'],
      imageRef: json['imageRef'],
    );
  }
}
