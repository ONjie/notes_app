import 'package:mongo_dart/mongo_dart.dart';

import '../Data Provider/data_provider.dart';
import '../Models/note.dart';

class NotesRepository{

  final DataProvider _dataProvider = DataProvider();

  Future<void> insertNotes({required Note note}) async{
    await _dataProvider.insertNote(note: note);
  }

  Future<List<Note>> getNotes() async{
    final notes = await _dataProvider.getNotes();
    return notes;
  }

  Future<Note> getNoteById({required ObjectId id}) async{
    final note = await _dataProvider.getNoteById(id: id);
    return note;

  }

  Future<void> updateNote({required Note note}) async{
    await _dataProvider.updateNote(note: note);
  }

  Future<void> deleteANote({required ObjectId id}) async{
    await _dataProvider.deleteNote(id: id);
  }



}
