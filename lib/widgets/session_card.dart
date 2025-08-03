import 'package:flutter/material.dart';

class SessionCard extends StatelessWidget {
  final String title;
  final String description;
  final String jsonFile;

  const SessionCard({
    super.key,
    required this.title,
    required this.description,
    required this.jsonFile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.play_circle_fill, color: Colors.teal),
        onTap: () {
          Navigator.pushNamed(context, '/modular', arguments: jsonFile);
        },
      ),
    );
  }
}
