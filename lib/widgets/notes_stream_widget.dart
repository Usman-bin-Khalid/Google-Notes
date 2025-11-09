import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_notes/models/notes_model.dart';
import 'package:google_notes/widgets/note_card.dart';
import 'package:google_notes/widgets/notes_grid_view.dart';
import 'package:google_notes/widgets/notes_reorderable_list.dart';


class NotesStreamWidget extends StatelessWidget {
  final bool isGridView;
  final Function(int oldIndex, int newIndex) onReorder;
  final Function(DismissDirection direction, Note note) onArchive;

  const NotesStreamWidget({
    super.key,
    required this.isGridView,
    required this.onReorder,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notes')
       
          .where('isArchived', isEqualTo: false) 
          .orderBy('position', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allActiveNotes = snapshot.data!.docs.map((doc) {
          return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
   
        final pinnedNotes = allActiveNotes.where((note) => note.isPinned).toList();
        final otherNotes = allActiveNotes.where((note) => !note.isPinned).toList();
        
        return SingleChildScrollView(
          child: Column(
            children: [
       
              if (pinnedNotes.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('PINNED', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
        
                _buildNotesList(context, pinnedNotes, isGridView, false), 
              ],
            
              if (otherNotes.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('OTHERS', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
              
                _buildNotesList(context, otherNotes, isGridView, true), 
              ],
            ],
          ),
        );
      },
    );
  }


  Widget _buildNotesList(BuildContext context, List<Note> notes, bool isGrid, bool isReorderable) {
    if (isGrid) {

      return NotesGridView(
        notes: notes,
        onArchive: onArchive,
       
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), 
      );
    } else {
      if (isReorderable) {
       
        return NotesReorderableList(
          notes: notes,
          onReorder: onReorder,
          onArchive: onArchive,
         
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );
      } else {
   
         return ListView.builder(
           shrinkWrap: true,
           physics: const NeverScrollableScrollPhysics(),
           itemCount: notes.length,
           itemBuilder: (context, index) {
             final note = notes[index];
            
             return NoteCard(note: note, isGrid: false);
           },
         );
      }
    }
  }
}