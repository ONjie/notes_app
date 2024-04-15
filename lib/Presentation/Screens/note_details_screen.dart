import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/Presentation/Screens/edit_note_screen.dart';

import '../../BLoC/notes_bloc.dart';
import '../../Data/Models/note_model.dart';
import '../widgets/widgets.dart';
import 'notes_screen.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({super.key, required this.noteId});

  final int noteId;

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  @override
  void initState() {
    BlocProvider.of<NotesBloc>(context)
        .add(FetchNoteByIdEvent(noteId: widget.noteId));
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (pop) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NotesScreen()));
      },
      child: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state.status == NotesStatus.deleted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotesScreen(),),);

          }

          if (state.status == NotesStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(displaySnackBarWidget(
              message: state.message!,
              color: Colors.red,
            ),
            );

          }

        },

        builder: (context, state) {
            if (state.status == NotesStatus.noteLoaded) {
              return Scaffold(
                appBar: buildAppBar(note: state.note!),
                body: buildBody(context: context, note: state.note!),
              );
            }
            if (state.status == NotesStatus.error) {
              return Center(
                child: Text(state.message!),
              );
            }
            return Container();
        },
      ),
    );
  }

  AppBar buildAppBar({required NoteModel note}) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: CupertinoColors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotesScreen()),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.edit_outlined,
            color: Colors.teal,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditNoteScreen(note: note)));
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.teal,
            size: 30,
          ),
          onPressed: () {
            BlocProvider.of<NotesBloc>(context).add(DeleteNoteEvent(noteId: widget.noteId));
          },
        ),
      ],
    );
  }

  Widget buildBody({required BuildContext context, required NoteModel note}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16, bottom: 0, right: 12, left: 12),
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
                DateFormat.yMMMd().format(note.creationTime),
                style: const TextStyle(color: Colors.white38),
              ),
              const SizedBox(height: 8),
              Text(
                note.description,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
