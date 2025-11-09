import 'package:flutter/material.dart';
import 'package:google_notes/models/notes_model.dart';
import 'package:google_notes/widgets/note_card.dart';

class NotesReorderableList extends StatelessWidget {
 final List<Note> notes;
  final Function(int oldIndex, int newIndex) onReorder;
  final Function(DismissDirection direction, Note note) onArchive;

  final bool shrinkWrap;
  final ScrollPhysics physics;

  const NotesReorderableList({
    super.key,
    required this.notes,
    required this.onReorder,
    required this.onArchive,
  
    required this.shrinkWrap,
    required this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
    
      shrinkWrap: shrinkWrap, 
      physics: physics,
      padding: const EdgeInsets.only(top: 8.0, bottom: 70.0),
      onReorder: onReorder,
      children: <Widget>[
        for (final note in notes)
         
          Dismissible(
           
            key: ValueKey(note.id), 
            
            direction: DismissDirection.horizontal, 

            
            background: Container(
              color: Colors.grey.shade700, 
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20.0),
              child: const Icon(Icons.archive_outlined, color: Colors.white, size: 30),
            ),

            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
            ),

            onDismissed: (direction) {
             
              onArchive(direction, note);

             
              if (direction == DismissDirection.startToEnd) {
             
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Note archived'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                     
                      },
                    ),
                  ),
                );
              } else if (direction == DismissDirection.endToStart) {
         
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note deleted')),
                );
              }
            },
            
            
            child: NoteCard(
              key: ValueKey(note.id),
              note: note,
              isGrid: false,
            ),
          ),
      ],
    );
  }
}