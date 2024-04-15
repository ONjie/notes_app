part of 'notes_bloc.dart';

enum NotesStatus {initial, loading, notesLoaded, empty,  noteLoaded, added, deleted, updated, error}

class NotesState extends Equatable {
  const NotesState({required this.status, this.notes, this.note, this.message,});

  final NotesStatus status;
  final List<NoteModel>? notes;
  final NoteModel? note;
  final String? message;

  @override
  List<Object?> get props => [status, notes, note, message,];

}
