import '../Data Provider/database.dart';
import '../Models/note_model.dart';

class NotesRepository {
  final appDatabase = AppDatabase();

  Future<int> addNote({required NoteModel note}) async {
    late int id = 0;
    try {
      id = await appDatabase.addNote(note: note);
    } catch (e) {
      e.toString();
    }
    return Future.value(id);
  }

  Future<List<NoteModel>> fetchNotes() async {
    late List<NoteModel> notes = [];
    try {
      notes = await appDatabase.fetchNotes();
    } catch (e) {
      e.toString();
    }

    return Future.value(notes);
  }

  Future<NoteModel> fetchNoteById({required int noteId}) async {
    late NoteModel note = NoteModel(
        id: -1, title: '', description: '', creationTime: DateTime.now());

    try {
      note = await appDatabase.fetchNote(noteId: noteId);
    } catch (e) {
      e.toString();
    }

    return Future.value(note);
  }

  Future<bool> updateNote({required NoteModel note}) async {
    late bool isUpdated = false;

    try {
      isUpdated = await appDatabase.updateNote(note: note);
    } catch (e) {
      e.toString();
    }

    return Future.value(isUpdated);
  }

  Future<bool> deleteNote({required int noteId}) async {
    late bool isDeleted = false;

    try {
      isDeleted = await appDatabase.deleteNote(noteId: noteId);
    } catch (e) {
      e.toString();
    }

    return Future.value(isDeleted);
  }
}
