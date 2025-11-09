import 'package:flutter/material.dart';

// archived_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_notes/models/notes_model.dart';
import 'package:google_notes/services/services.dart';
import 'package:google_notes/widgets/note_card.dart'; // Re-using NoteCard for simplicity
import 'package:flutter/widgets.dart'; // Required for DismissDirection


class ArchivedScreen extends StatefulWidget {
  const ArchivedScreen({super.key});

  @override
  State<ArchivedScreen> createState() => _ArchivedScreenState();
}

class _ArchivedScreenState extends State<ArchivedScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isGridView = false; // State for toggling grid/list view in archive

  // Function to handle unarchiving a note
  void _handleUnarchive(DismissDirection direction, Note note) async {
    // Only unarchive if swiped from left to right (startToEnd)
    if (direction == DismissDirection.startToEnd) {
      print('Unarchiving note: ${note.id}');
      await _firestoreService.unarchiveNote(note.id); // New method in FirestoreService

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Note unarchived'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              // OPTIONAL: Implement UNDO for unarchive.
              // This would typically involve archiving it again.
            },
          ),
        ),
      );
    } else if (direction == DismissDirection.endToStart) {
       // OPTIONAL: Implement delete from archive if swiped right-to-left
       print('Deleting note from archive: ${note.id}');
       await _firestoreService.deleteNote(note.id); // You'd need a delete method in FirestoreService
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note deleted permanently')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Notes'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            // Query for archived notes
            .where('isArchived', isEqualTo: true)
            .orderBy('position', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('ArchivedScreen Error: ${snapshot.error}'); // Debugging
            return const Center(child: Text('Something went wrong loading archived notes'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final archivedNotes = snapshot.data!.docs.map((doc) {
            return Note.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          if (archivedNotes.isEmpty) {
            return const Center(child: Text('No archived notes yet.'));
          }

          // Use similar widgets as your main screen for display
          if (_isGridView) {
            // For grid view, you might need a dedicated NotesArchiveGridView
            // For now, let's reuse NotesGridView with the onArchive callback adjusted
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Matches your main grid
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: archivedNotes.length,
              itemBuilder: (context, index) {
                final note = archivedNotes[index];
                return Dismissible(
                  key: ValueKey(note.id),
                  direction: DismissDirection.horizontal, // Swipe to unarchive/delete
                  background: Container(
                    color: Colors.blue, // Unarchive color
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: const Icon(Icons.unarchive_outlined, color: Colors.white, size: 30),
                  ),
                   secondaryBackground: Container(
                    color: Colors.red, // Delete color
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
                  ),
                 onDismissed: (direction) {
    // 💡 FIX: Wrap the call to pass the 'note' object
    _handleUnarchive(direction, note); 
  },// Use the unarchive handler
                  child: NoteCard(note: note, isGrid: true),
                );
              },
            );
          } else {
            // Re-using NotesReorderableList, but need to pass correct handler
            return ReorderableListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 70.0),
              itemCount: archivedNotes.length,
              onReorder: (oldIndex, newIndex) {
                 // Reordering in archive might need special handling
                 // For now, let's just print a message, or simply disable reorder for archived
                 print('Reordering archived notes is not yet fully implemented.');
              },
              itemBuilder: (context, index) {
                final note = archivedNotes[index];
                return Dismissible(
                  key: ValueKey(note.id),
                  direction: DismissDirection.horizontal, // Swipe to unarchive/delete
                  background: Container(
                    color: Colors.blue, // Unarchive color
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: const Icon(Icons.unarchive_outlined, color: Colors.white, size: 30),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red, // Delete color
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
                  ),
             onDismissed: (direction) {
    // 💡 FIX: Wrap the call to pass the 'note' object
    _handleUnarchive(direction, note); 
  }, // Use the unarchive handler
                  child: NoteCard(note: note, isGrid: false),
                );
              },
            );
          }
        },
      ),
    );
  }
}