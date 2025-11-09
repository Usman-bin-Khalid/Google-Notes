import 'package:flutter/material.dart';
import 'package:google_notes/services/services.dart';

class NoteEditorScreen extends StatelessWidget {
  NoteEditorScreen({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  void _saveNote(BuildContext context) async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isNotEmpty || content.isNotEmpty) {
      await _firestoreService.addNote(title, content);
      // Once saved, pop the screen to go back to the list
      Navigator.pop(context);
    } else {
      // Optional: Show a snackbar or alert if both fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          // The Save/Done button
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _saveNote(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Title Input
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Content Input
            Expanded(
              child: TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  hintText: 'Note',
                  border: InputBorder.none,
                ),
                maxLines: null, // Allows for unlimited lines
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}