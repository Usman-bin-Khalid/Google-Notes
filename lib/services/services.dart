import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_notes/models/notes_model.dart';
Future<void> updateNoteOrder(List<Note> notes, int oldIndex, int newIndex) async {

  if (newIndex > oldIndex) {
    newIndex -= 1;
  }

  final Note movedNote = notes.removeAt(oldIndex);
  notes.insert(newIndex, movedNote);

  final batch = FirebaseFirestore.instance.batch();
  for (int i = 0; i < notes.length; i++) {
    final noteRef = FirebaseFirestore.instance.collection('notes').doc(notes[i].id);
    batch.update(noteRef, {'position': i});
  }

  await batch.commit();
}

class FirestoreService {
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  Future<int> getNextNotePosition() async {
 
    final querySnapshot = await notesCollection
        .orderBy('position', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return 0;
    }
    
    final lastPosition = querySnapshot.docs.first['position'] as int? ?? 0;
    return lastPosition + 1;
  }

  Future<Future<DocumentReference<Object?>>> addNote(String title, String content) async {
    final nextPosition = await getNextNotePosition();

    return notesCollection.add({
      'title': title,
      'content': content,
      'position': nextPosition, 
      'createdAt': Timestamp.now(),
  
      'isArchived': false, 
    });
  }

  Future<void> unarchiveNote(String noteId) async {
    await notesCollection.doc(noteId).update({'isArchived': false});
  }

  Future<void> deleteNote(String noteId) async {
    await notesCollection.doc(noteId).delete();
  }

  Future<void> archiveNote(String noteId) async {
    await notesCollection.doc(noteId).update({'isArchived': true});
  }

  
}