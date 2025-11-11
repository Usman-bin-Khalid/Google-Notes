import 'package:flutter/material.dart';
import 'package:google_notes/services/services.dart';
import 'package:google_notes/views/screens/archieved_screen.dart';
import 'package:google_notes/views/screens/help_screen.dart';
import 'package:google_notes/views/screens/notes_editor_screen.dart';
import 'package:google_notes/views/screens/settings_screen.dart';
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
  final TextEditingController _searchTextController = TextEditingController();
  String _searchQuery = '';
  void _handleReorder(int oldIndex, int newIndex) async {
    print(
      'Reorder initiated. This needs to fetch the current active notes to update positions in Firestore.',
    );
  }

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_onSearchChanged);
    _searchTextController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Update the state with the current text field value
    setState(() {
      _searchQuery = _searchTextController.text;
    });
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Note deleted')));
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
      backgroundColor: Color(0xffffe9db),
      appBar: AppBar(
        backgroundColor: const Color(0xffffe9db),
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _searchTextController,
                      decoration: const InputDecoration(
                        hintText: 'Search Keep',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 8),
                      ),
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(
                    _isGridView ? Icons.view_list : Icons.grid_view,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _isGridView = !_isGridView;
                    });
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                child: Text(
                  'Google Keep',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ListTile(
                  selected: true,
                  selectedTileColor: Colors.amber.withOpacity(0.2),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),

                  leading: const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.black54,
                  ),
                  title: const Text(
                    'Notes',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              ListTile(
                leading: const Icon(
                  Icons.notifications_none,
                  color: Colors.black54,
                ),
                title: const Text('Reminders'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const Divider(),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.black54),
                title: const Text('Create new label'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NoteEditorDialog()),
                  );
                },
              ),
              const Divider(),

              ListTile(
                leading: const Icon(
                  Icons.archive_outlined,
                  color: Colors.black54,
                ),
                title: const Text('Archive'),
                onTap: () {
                  Navigator.pop(context);
                  _goToArchiveScreen(context);
                },
              ),

              // 5. Deleted
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.black54,
                ),
                title: const Text('Deleted'),
                onTap: () {
                  Navigator.pop(context);
                  // _goToDeletedScreen(context);
                },
              ),

              // 6. Settings
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: Colors.black54,
                ),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),

              // 7. Help & feedback
              ListTile(
                leading: const Icon(Icons.help_outline, color: Colors.black54),
                title: const Text('Help & feedback'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpApp()),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NotesStreamWidget(
          isGridView: _isGridView,
          onReorder: _handleReorder,
          onArchive: _handleArchive,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteEditorDialog()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
