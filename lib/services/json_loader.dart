import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/pose_model.dart';

class JSONLoader {
  static Future<List<Pose>> loadPoses() async {
    final data = await rootBundle.loadString('assets/poses.json');
    final List posesJson = json.decode(data);
    return posesJson.map((e) => Pose.fromJson(e)).toList();
  }
}
