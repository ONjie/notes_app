part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  const NotesState();
}

class NotesInitial extends NotesState {
  @override
  List<Object> get props => [];
}
class NotesLoadingState extends NotesState {
  @override
  List<Object> get props => [];
}

class NotesLoadedState extends NotesState {
  final List<Note> note;

  const NotesLoadedState({required this.note});
  @override
  List<Object> get props => [note];
}

class NoteLoadedSuccessfullyState extends NotesState {
  final Note note;

  const NoteLoadedSuccessfullyState({required this.note});
  @override
  List<Object> get props => [note];
}

class LoadNotesErrorState extends NotesState{
  final String errorMessage;

  const LoadNotesErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class NoteCreatedSuccessfullyState extends NotesState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
