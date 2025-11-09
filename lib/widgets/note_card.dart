import 'package:flutter/material.dart';
import 'package:google_notes/models/notes_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final bool isGrid;

  const NoteCard({
    Key? key,
    required this.note,
    required this.isGrid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow[100],
      elevation: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              note.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
        
            Text(
              note.content,
              maxLines: isGrid ? 3 : 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}