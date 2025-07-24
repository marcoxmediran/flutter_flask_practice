import 'package:flutter/material.dart';
import 'package:notes_app/src/api/api_service.dart';
import 'package:notes_app/src/model/note_model.dart';

class NotesScreenPage extends StatefulWidget {
  const NotesScreenPage({super.key});

  @override
  State<NotesScreenPage> createState() => _NotesScreenPage();
}

class _NotesScreenPage extends State<NotesScreenPage> {
  late Future<List<Note>> _notesFuture;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() {
    setState(() {
      _notesFuture = ApiService.getNotes();
    });
  }

  void _deleteNote(int id) {
    ApiService.deleteNote(id);
    _fetchNotes();
  }

  void _showNoteDialog({Note? note}) {
    bool isEditing = (note != null);
    if (isEditing) {
      _titleController.text = note.title;
      _contentController.text = note.content;
    } else {
      _titleController.clear();
      _contentController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Note' : 'Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (isEditing) {
                  await ApiService.updateNote(
                    note.id,
                    _titleController.text,
                    _contentController.text,
                  );
                } else {
                  await ApiService.createNote(
                    _titleController.text,
                    _contentController.text,
                  );
                }
                Navigator.of(context).pop();
                _fetchNotes();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Notes App'),
      ),
      body: FutureBuilder(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notes found.'));
          }

          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (content, index) {
              final note = notes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Edit functionality
                          _showNoteDialog(note: note);
                        },
                        icon: Icon(Icons.edit, color: Colors.grey),
                      ),
                      IconButton(
                        onPressed: () {
                          // Delete functionality
                          _deleteNote(note.id);
                        },
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
