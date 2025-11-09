import 'package:flutter/material.dart';
import 'package:google_notes/models/notes_model.dart';
import 'package:google_notes/widgets/note_card.dart';


class NotesGridView extends StatelessWidget {
  final List<Note> notes;
  final Function(DismissDirection direction, Note note) onArchive;
  

  final bool shrinkWrap;
  final ScrollPhysics physics;
  const NotesGridView({
    super.key,
    required this.notes,
    required this.onArchive,
 
    required this.shrinkWrap,
    required this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
    
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        
        return Dismissible(
          key: ValueKey(note.id),
          direction: DismissDirection.horizontal,
          background: Container(),
          secondaryBackground: Container(  ),
          onDismissed: (direction) {
      
            onArchive(direction, note);
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(direction == DismissDirection.startToEnd ? 'Note archived' : 'Note deleted'),
              
              ),
            );
          },
          child: NoteCard(
            key: ValueKey(note.id),
            note: note,
            isGrid: true,
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
    );
  }
}