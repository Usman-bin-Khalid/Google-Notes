import 'package:flutter/material.dart';
import 'package:google_notes/services/services.dart';
import 'package:google_notes/views/screens/archieved_screen.dart';
import 'package:google_notes/views/screens/notes_edit_screen.dart';
import 'package:google_notes/widgets/notes_stream_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_notes/models/notes_model.dart';
import 'package:flutter/widgets.dart';


class KeepCloneScreen extends StatefulWidget {
  const KeepCloneScreen({super.key});

  @override
  State<KeepCloneScreen> createState() => _KeepCloneScreenState();
}

class _KeepCloneScreenState extends State<KeepCloneScreen> {
  bool _isGridView = false;
  final FirestoreService _firestoreService = FirestoreService(); 
  void _handleReorder(int oldIndex, int newIndex) async {
  
    print('Reorder initiated. This needs to fetch the current active notes to update positions in Firestore.');
  
  }

  
  void _handleArchive(DismissDirection direction, Note note) async {
    if (direction == DismissDirection.startToEnd) {
  
      print('Archiving note: ${note.id}');
      await _firestoreService.archiveNote(note.id); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Note archived'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              _firestoreService.unarchiveNote(note.id);
            },
          ),
        ),
      );
    } else if (direction == DismissDirection.endToStart) {
     
      print('Deleting note: ${note.id}');
      await _firestoreService.deleteNote(note.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted')),
      );
    }
  }

  void _goToArchiveScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ArchivedScreen()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keep Clone'),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Text('Google Keep Clone', style: TextStyle(color: Colors.black, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Notes'),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive'),
              onTap: () {
                Navigator.pop(context); 
                _goToArchiveScreen(context); 
              },
            ),
          ],
        ),
      ),
      body: NotesStreamWidget( 
        isGridView: _isGridView,
        onReorder: _handleReorder, 
        onArchive: _handleArchive,   
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteEditorScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}