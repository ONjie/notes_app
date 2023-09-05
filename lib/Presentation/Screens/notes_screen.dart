import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';


import '../../BLoC/notes_bloc.dart';
import '../../Data/Models/note.dart';
import 'create_note_screen.dart';
import 'note_details_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {


  @override
  void initState() {
    BlocProvider.of<NotesBloc>(context).add(const GetAllNotesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context: context),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  AppBar buildAppBar() => AppBar(
    automaticallyImplyLeading: false,
    title: const Center(
      child: Text(
        'Notes',
        style: TextStyle(fontSize: 24),
      ),
    ),
  );

  Widget buildBody({required BuildContext context}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child:  Padding(
          padding: const EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 0),
          child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state){
                if(state is NotesLoadedState){
                  List<Note> notes = state.note;

                  return buildNotesGridView(notes: notes);

                }
                if(state is LoadNotesErrorState){
                  return  Center(
                    child: Text(
                     state.errorMessage,
                      style: const TextStyle(
                        fontSize: 20,
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: CupertinoColors.white,)
                );
              }
          ),
        ),
      ),
    );
  }

  Widget buildNotesGridView({required List<Note> notes}){
    return GridView.custom(
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: [
          const QuiltedGridTile(2, 2),
          const QuiltedGridTile(2, 2),
          const QuiltedGridTile(2, 4),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
          childCount: notes.length,
              (context, index){
            final note = notes[index];
            final color = _lightColors[index % _lightColors.length];
            final time = DateFormat.yMMMd().format(note.createdTime);
            return ClipRect(
              child: GestureDetector(
                onTap: () async{
                  context.read<NotesBloc>().add(GetANoteEvent(id: note.id));
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteDetailsScreen(noteId: note.id),
                  ),
                  );
                },
                child: buildNoteCard(note: note, time: time, color: color),
              ),
            );
          }
      ),
    );
  }

  Widget buildNoteCard({required Note note, required String time, required Color color}) => Card(
    color: color,
    child: Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    ),
  );

  Widget buildFloatingActionButton() => FloatingActionButton(
    backgroundColor: Colors.teal,
    child: const Icon(Icons.add, color: CupertinoColors.white,),
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => const CreateNoteScreen()),
      );
    },
  );

}

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];
