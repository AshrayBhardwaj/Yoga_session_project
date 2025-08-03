import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'modular_session_screen.dart';

class SessionListScreen extends StatefulWidget {
  const SessionListScreen({super.key});

  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  List<Map<String, dynamic>> sessions = [];

  @override
  void initState() {
    super.initState();
    loadSessionList();
  }

  Future<void> loadSessionList() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final sessionFiles = manifestMap.keys
        .where((String key) => key.contains('assets/sessions/') && key.endsWith('.json'))
        .toList();

    List<Map<String, dynamic>> sessionList = [];

    for (String path in sessionFiles) {
      final jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> sessionJson = json.decode(jsonString);
      sessionList.add({
        'path': path.replaceAll('assets/sessions/', ''),
        'title': sessionJson['metadata']['title'],
        'description': sessionJson['metadata']['category'],
      });
    }

    setState(() {
      sessions = sessionList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Sessions'),
        backgroundColor: Colors.teal,
      ),
      body: sessions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return Card(
                  child: ListTile(
                    title: Text(session['title']),
                    subtitle: Text('Category: ${session['description']}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ModularSessionScreen(
                            jsonFileName: session['path'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
