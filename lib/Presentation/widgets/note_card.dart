import 'package:flutter/material.dart';

import '../../Data/Models/note_model.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.note, required this.time, required this.color});
  final NoteModel note;
  final String time;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            //const SizedBox(height: 6),
            const Spacer(),
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }
}
