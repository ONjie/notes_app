part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
}

class AddNoteEvent extends NotesEvent {
  final NoteModel note;

  const AddNoteEvent({required this.note});

  @override
  List<Object?> get props => [note];
}

class UpdateNoteEvent extends NotesEvent {
  final NoteModel note;
  const UpdateNoteEvent({required this.note});
  @override
  List<Object?> get props => [note];
}

class FetchNotesEvent extends NotesEvent {
  const FetchNotesEvent();

  @override
  List<Object?> get props => [];
}

class FetchNoteByIdEvent extends NotesEvent {
  final int noteId;
  const FetchNoteByIdEvent({required this.noteId});

  @override
  List<Object?> get props => [noteId];
}

class DeleteNoteEvent extends NotesEvent {
  final int noteId;
  const DeleteNoteEvent({required this.noteId});
  @override
  List<Object?> get props => [noteId];
}
