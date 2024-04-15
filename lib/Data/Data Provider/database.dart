import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

import '../Models/note_model.dart';

part 'database.g.dart';

class Notes extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get creationTime => text()();
}

@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> addNote({required NoteModel note}) async {
    final noteToBeAdded = note.toNote();

    final addedNoteId = await into(notes).insert(NotesCompanion.insert(
      title: noteToBeAdded.title,
      description: noteToBeAdded.description,
      creationTime: noteToBeAdded.creationTime,
    ));

    return Future.value(addedNoteId);
  }

  Future<bool> deleteNote({required int noteId}) async {
    final trueOrFalse =
        await (delete(notes)..where((tbl) => tbl.id.equals(noteId))).go() == 1;

    return Future.value(trueOrFalse);
  }

  Future<NoteModel> fetchNote({required int noteId}) async {
    final note = await (select(notes)..where((tbl) => tbl.id.equals(noteId)))
        .getSingle();

    final fetchedNote = NoteModel.fromNote(note);

    return Future.value(fetchedNote);
  }

  Future<List<NoteModel>> fetchNotes() async {
    final result = await select(notes).get();

    List<NoteModel> fetchedNotes =
        result.map((note) => NoteModel.fromNote(note)).toList();

    return Future.value(fetchedNotes);
  }

  Future<bool> updateNote({required NoteModel note}) async {
    final noteUpdate = note.toNote();

    final trueOrFalse = await update(notes).replace(Note(
      id: noteUpdate.id,
      title: noteUpdate.title,
      description: noteUpdate.description,
      creationTime: noteUpdate.creationTime,
    ));

    return Future.value(trueOrFalse);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cacheBase = (await getTemporaryDirectory()).path;

    sqlite3.tempDirectory = cacheBase;

    return NativeDatabase.createInBackground(file);
  });
}
