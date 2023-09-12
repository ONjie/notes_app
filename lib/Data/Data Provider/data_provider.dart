import 'package:mongo_dart/mongo_dart.dart';
import '../Models/note.dart';

class DataProvider{

  /// Notes Collection
static late DbCollection notesCollection;


/// Initialize Mongodb and connect to your database
static initDatabaseConnection() async{
  /// Your mongoDB connection url
 Db db = await Db.create("mongodb+srv://username:password@cluster0.gxhjute.mongodb.net/database_name?retryWrites=true&w=majority");
  await db.open();
  notesCollection = db.collection(collection_name);
}

/// Creates a new note document with a unique _id
Future<void> insertNote({required Note note}) async{
  try{
    /// Inserts the note's data into document
    await notesCollection.insert(note.toJson());

  }catch(e){e.toString();}
}


/// Gets all the documents in the notes collection and return them in a form of List<Note>
Future<List<Note>> getNotes() async{

 late List<Note> notes;

  try{
    /// gets the documents and convert them to a list
    final results = await notesCollection.find().toList();

    /// Maps the results to Note.from and converts it to a list
   notes = results.map((e) => Note.fromJson(e)).toList();

  }
  catch(e){e.toString();}

 /// returns a list of notes
  return notes;
}


/// Gets a note document within notes collection where the note's id = notes.id and returns the note's data
Future<Note> getNoteById({required ObjectId id}) async{

 late Note note;

 try{
   /// Queries and gets a note where its id = notes.id
   final results = await notesCollection.findOne(where.eq('id', id));

   /// converts the results to Note using Note.from()
    note = Note.fromJson(results!);

 }
 catch(e){e.toString();}

 /// returns the note
 return note;
}


/// Updates a note document within the notes collection where id = notes.id
Future<void> updateNote({required Note note}) async{

  try{
    /// updates the note's document data
    await notesCollection.replaceOne(where.eq('id', note.id), note.toJson());


  }catch(e){e.toString();}

}


/// Deletes a note document within notes collection where the note's id = notes.id
Future<void> deleteNote({required ObjectId id}) async{
  try{
    /// deletes the note's document
    await notesCollection.remove(where.eq('id', id));
  }
  catch(e){e.toString();}
}



}