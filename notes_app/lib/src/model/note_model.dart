class Note {
  final int id;
  final String title;
  final String content;
  final DateTime dateCreated;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.dateCreated
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      dateCreated: DateTime.parse(json['date_created']),
    );
  }
}
