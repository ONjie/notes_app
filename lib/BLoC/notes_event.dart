part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
}

class AddNoteEvent extends NotesEvent {
  final ObjectId id;
  final String title;
  final String description;
  final DateTime createdTime;

  const AddNoteEvent({required this.id,required this.title, required this.description, required this.createdTime,});

  @override
  List<Object?> get props => [title, description, createdTime];
}

class UpdateNoteEvent extends NotesEvent {
  final Note note;
  const UpdateNoteEvent({required this.note});
  @override
  List<Object?> get props => [note];
}

class GetAllNotesEvent extends NotesEvent {
  const GetAllNotesEvent();

  @override
  List<Object?> get props => [];
}

class GetANoteEvent extends NotesEvent {
  final ObjectId id;
  const GetANoteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteNoteEvent extends NotesEvent {
  final ObjectId id;
  const DeleteNoteEvent({required this.id});
  @override
  List<Object?> get props => [id];
}
