import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;


import '../../BLoC/notes_bloc.dart';
import '../../Data/Models/note.dart';
import 'edit_note_screen.dart';
import 'notes_screen.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({super.key, required this.noteId});

 final mongo_dart.ObjectId noteId;

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(builder: (context,state){
      if(state is NoteLoadedSuccessfullyState){
        Note note = state.note;
         return Scaffold(
          appBar: buildAppBar(note: note),
          body: buildBody(context: context, note: note),
        );
      }
      if(state is LoadNotesErrorState){
        return Center( child: Text(state.errorMessage),);
      }
      return Container();
    });
  }

  AppBar buildAppBar({required Note note}) => AppBar(
    automaticallyImplyLeading: false,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotesScreen()),);
      },
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () async {
          BlocProvider.of<NotesBloc>(context).add(GetANoteEvent(id: widget.noteId));
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditNoteScreen(note: note),
          )
          );
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          BlocProvider.of<NotesBloc>(context).add(DeleteNoteEvent(id: widget.noteId));
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>const NotesScreen()));
        },
      ),
    ],
  );

  Widget buildBody({required BuildContext context, required Note note}){
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 0, right: 12, left: 12),
            child: buildNoteContainer(note: note),
          ),
        ),
    );
  }

  Widget buildNoteContainer({required Note note}) => Container(
    padding: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          note.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat.yMMMd().format(note.createdTime),
          style: const TextStyle(color: Colors.white38),
        ),
        const SizedBox(height: 8),
        Text(
          note.description,
          style:
          const TextStyle(color: Colors.white70, fontSize: 18),
        )
      ],
    ),
  );
}
