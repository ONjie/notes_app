import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../Data/Data Repository/notes_repository.dart';
import '../Data/Models/note_model.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super( NotesState(status: NotesStatus.initial,)) {
    on<AddNoteEvent>(_onAddNote);
    on<FetchNotesEvent>(_onFetchNotes);
    on<FetchNoteByIdEvent>(_onFetchNoteById);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
  }
  final NotesRepository _notesRepository = NotesRepository();

  _onAddNote(AddNoteEvent event, Emitter<NotesState> emit) async {
    final id = await _notesRepository.addNote(note: event.note);

    if (id != 0) {
      emit(
        const NotesState(
          status: NotesStatus.added,
        ),
      );
    } else {
      emit(
        const NotesState(
          status: NotesStatus.error,
          message: 'Failed to add note',
        ),
      );
    }
  }

  _onFetchNotes(FetchNotesEvent event, Emitter<NotesState> emit) async {

    emit(
      const NotesState(
        status: NotesStatus.loading,
      ),
    );

    final notes = await _notesRepository.fetchNotes();

    if (notes.isNotEmpty) {
      emit(
        NotesState(
          status: NotesStatus.notesLoaded,
          notes: notes,
        ),
      );
    } else {
      emit(
        const NotesState(
          status: NotesStatus.empty,
          message: 'No notes yet!',
        ),
      );
    }
  }

  _onFetchNoteById(FetchNoteByIdEvent event, Emitter<NotesState> emit) async {
    final note = await _notesRepository.fetchNoteById(noteId: event.noteId);

    if (note.id! > 0) {
      emit(
        NotesState(
          status: NotesStatus.noteLoaded,
          note: note,
        ),
      );
    } else {
      emit(
        NotesState(
          status: NotesStatus.error,
          message: 'Note with such id:${event.noteId} doesn\'t exist',
        ),
      );
    }
  }

  _onUpdateNote(UpdateNoteEvent event, Emitter<NotesState> emit) async {
    final isUpdated = await _notesRepository.updateNote(note: event.note);

    if (isUpdated == true) {
      emit(
        const NotesState(
          status: NotesStatus.updated,
        ),
      );
    } else {
      emit(
        const NotesState(
          status: NotesStatus.error,
          message: 'Failed to update note',
        ),
      );
    }
  }

  _onDeleteNote(DeleteNoteEvent event, Emitter<NotesState> emit) async {
    final isDeleted = await _notesRepository.deleteNote(noteId: event.noteId);

    if (isDeleted == true) {
      emit(
        const NotesState(
          status: NotesStatus.deleted,
        ),
      );
    } else {
      emit(
         const NotesState(
          status: NotesStatus.error,
          message: 'Failed to delete note',
        ),
      );
    }
  }
}
