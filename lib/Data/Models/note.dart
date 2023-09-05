
import 'package:mongo_dart/mongo_dart.dart';

class NoteFields {

  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'date';
}

class Note {
  final ObjectId id;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    required this.id,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Note copy({
    ObjectId? id,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Note fromJson(Map<String, dynamic> json) => Note(
    id: json[NoteFields.id] as ObjectId,
    title: json[NoteFields.title] as String,
    description: json[NoteFields.description] as String,
    createdTime: DateTime.parse(json[NoteFields.time] as String),
  );

  Map<String, dynamic> toJson() => {
    NoteFields.id: id,
    NoteFields.title: title,
    NoteFields.description: description,
    NoteFields.time: createdTime.toIso8601String(),
  };
}