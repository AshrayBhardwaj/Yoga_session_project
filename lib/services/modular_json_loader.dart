import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/modular_pose_model.dart';

class ModularJSONLoader {
  static Future<ModularFlow> loadFlow(String jsonFileName) async {
    final jsonString = await rootBundle.loadString('assets/sessions/$jsonFileName');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return ModularFlow.fromJson(jsonData);
  }
}
