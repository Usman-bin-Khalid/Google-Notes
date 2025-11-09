// Note: You would place this logic in the parent stateful widget or a service.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_notes/models/notes_model.dart'; // Ensure Note model is imported

// This function is generally fine as it doesn't rely on the isArchived state
Future<void> updateNoteOrder(List<Note> notes, int oldIndex, int newIndex) async {
  // Logic to handle index change:
  if (newIndex > oldIndex) {
    newIndex -= 1;
  }

  final Note movedNote = notes.removeAt(oldIndex);
  notes.insert(newIndex, movedNote);

  // Batch write to update 'position' field for all notes in the new order
  final batch = FirebaseFirestore.instance.batch();
  for (int i = 0; i < notes.length; i++) {
    final noteRef = FirebaseFirestore.instance.collection('notes').doc(notes[i].id);
    batch.update(noteRef, {'position': i});
  }

  // Commit the changes to Firebase
  await batch.commit();
}

// Service to handle all Firestore interactions
class FirestoreService {
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  // Function to get the next available 'position'
  Future<int> getNextNotePosition() async {
    // NOTE: This query should probably only look at non-archived notes 
    // if you want 'position' to only relate to the currently visible list.
    // For now, we'll keep it broad to avoid introducing another index.
    final querySnapshot = await notesCollection
        .orderBy('position', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return 0; // First note starts at position 0
    }
    // Get the position of the last note and add 1
    final lastPosition = querySnapshot.docs.first['position'] as int? ?? 0;
    return lastPosition + 1;
  }

  // Function to save a new note
  // 💡 MODIFIED: Added the 'isArchived: false' field.
  Future<Future<DocumentReference<Object?>>> addNote(String title, String content) async {
    final nextPosition = await getNextNotePosition();

    return notesCollection.add({
      'title': title,
      'content': content,
      'position': nextPosition, // Set the position for the new note
      'createdAt': Timestamp.now(),
      
      // 🚨 NEW: Explicitly set isArchived to false for new notes
      'isArchived': false, 
    });
  }

  Future<void> unarchiveNote(String noteId) async {
    await notesCollection.doc(noteId).update({'isArchived': false});
  }

  // OPTIONAL: Function to delete a note permanently
  Future<void> deleteNote(String noteId) async {
    await notesCollection.doc(noteId).delete();
  }

  Future<void> archiveNote(String noteId) async {
    await notesCollection.doc(noteId).update({'isArchived': true});
  }

  
}