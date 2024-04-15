

import '../Data Provider/database.dart';

class NoteModel {
  final int?  id;
  final String title;
  final String description;
  final DateTime creationTime;

  const NoteModel({
    this.id,
    required this.title,
    required this.description,
    required this.creationTime,
  });


  static NoteModel fromNote(Note note) => NoteModel(
      id: note.id,
      title: note.title,
      description: note.description,
      creationTime: DateTime.parse(note.creationTime),
  );

  Note toNote() => Note(
      id: id,
      title: title,
      description: description,
      creationTime: creationTime.toIso8601String(),
  );


}