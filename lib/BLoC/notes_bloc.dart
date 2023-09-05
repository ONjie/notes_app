import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';


import '../Data/Data Repository/notes_repository.dart';
import '../Data/Models/note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesInitial()) {
    on<AddNoteEvent>(_onAddNote);
    on<GetAllNotesEvent>(_onGetAllNotes);
    on<GetANoteEvent>(_onGetANote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
  }
  final NotesRepository _notesRepository = NotesRepository();

  _onAddNote(AddNoteEvent event, Emitter<NotesState> emit) async{
    try{
        await _notesRepository.insertNotes(
            note: Note(
                id: event.id,
                title: event.title,
                description: event.description,
                createdTime: event.createdTime,
            ),
        ).whenComplete(() => emit(NoteCreatedSuccessfullyState(),),);
    }catch(e){e.toString();}

  }

  _onGetAllNotes(GetAllNotesEvent event, Emitter<NotesState> emit) async{
    try{
      final notes = await _notesRepository.getNotes();

      if(notes.isEmpty){
        emit(const LoadNotesErrorState(errorMessage: 'No Notes'));
      }
      else{
        emit(NotesLoadedState(note: notes));
      }

    }catch(e){e.toString();}

  }

  _onGetANote(GetANoteEvent event, Emitter<NotesState> emit) async{
    try{
     final note = await _notesRepository.getNoteById(id: event.id);
        emit(NoteLoadedSuccessfullyState(note: note),);
    }catch(e){
     // emit(const FetchNotesError(errorMessage: 'Unable to find the note'));
    }

  }

  _onUpdateNote(UpdateNoteEvent event, Emitter<NotesState> emit)async{
    try{
      await _notesRepository.updateNote(
          note: Note(
              id: event.note.id,
              title: event.note.title,
              description: event.note.description,
              createdTime: event.note.createdTime,
          ),
      );


    }catch(e){e.toString();}

  }

  _onDeleteNote(DeleteNoteEvent event, Emitter<NotesState> emit) async{
    try{
      await _notesRepository.deleteANote(id: event.id);
    }
    catch(e){e.toString();}

  }



}
