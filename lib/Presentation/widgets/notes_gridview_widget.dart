import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import '../../Data/Models/note_model.dart';
import '../Screens/note_details_screen.dart';
import '../colors.dart';
import 'widgets.dart';


class NotesGridviewWidget extends StatelessWidget {
  const NotesGridviewWidget({super.key, required this.notes});
 final List<NoteModel> notes;

  @override
  Widget build(BuildContext context) {
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
            final color = lightColors[index % lightColors.length];
            final time = DateFormat.yMMMd().format(note.creationTime);
            return ClipRect(
              child: GestureDetector(
                onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NoteDetailsScreen(noteId: note.id!,)));
                },
                child: NoteCard(note: note, time: time, color: color),
              ),
            );
          }
      ),
    );
  }
}
