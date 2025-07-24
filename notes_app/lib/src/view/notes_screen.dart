import 'package:flutter/material.dart';

class NotesScreenPage extends StatefulWidget {
  const NotesScreenPage({super.key});

  @override
  State<NotesScreenPage> createState() => _NotesScreenPage();
}

class _NotesScreenPage extends State<NotesScreenPage> {
  List<Map<String, dynamic>> _notes = [
    {
      'id': 1,
      'title': 'My First Note',
      'content': 'The quick brown fox jumps over the lazy dog.',
    },
    {'id': 2, 'title': 'The Second Note', 'content': 'Lorem ipsum dolor amet.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Notes App'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (content, index) {
          final note = _notes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(note['title']),
              subtitle: Text(note['content']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      // Edit functionality
                    },
                    icon: Icon(Icons.edit, color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: () {
                      // Delete functionality
                    },
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
