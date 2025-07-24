import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_app/src/model/note_model.dart';

class ApiService {
  // Set API URL for emulator
  static const String _baseUrl = 'http://10.0.2.2:5000';

  // POST
  static Future<void> createNote(String title, String content) async {
    final url = Uri.parse('$_baseUrl/notes');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'content': content}),
    );
  }

  // GET
  static Future<List<Note>> getNotes() async {
    final url = Uri.parse('$_baseUrl/notes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Note> notes = body
          .map((dynamic item) => Note.fromJson(item))
          .toList();
      return notes;
    } else {
      throw Exception('Failed to load notes.');
    }
  }

  // PUT
  static Future<void> updateNote(int id, String title, String content) async {
    final url = Uri.parse('$_baseUrl/notes/$id');
    await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'content': content}),
    );
  }

  // DELETE
  static Future<void> deleteNote(int id) async {
    final url = Uri.parse('$_baseUrl/notes/$id');
    await http.delete(url);
  }
}
