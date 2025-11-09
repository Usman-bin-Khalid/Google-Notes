import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_notes/models/notes_model.dart';
import 'package:google_notes/widgets/note_card.dart';

class DraggableNote extends StatefulWidget {
  final Note note;

  const DraggableNote({super.key, required this.note});

  @override
  State<DraggableNote> createState() => _DraggableNoteState();
}

class _DraggableNoteState extends State<DraggableNote> {
  // Use the stored x and y from the database as initial position
  double _x = 0.0;
  double _y = 0.0;
  
  // Reference to the note document for updating
  late DocumentReference noteRef;

  @override
  void initState() {
    super.initState();
    _x = widget.note.x;
    _y = widget.note.y;
    noteRef = FirebaseFirestore.instance.collection('notes').doc(widget.note.id);
  }

  // Function to update the note's position in Firebase
  void _updatePositionInFirebase() {
    noteRef.update({
      'x': _x,
      'y': _y,
    });
  }

  @override
  Widget build(BuildContext context) {
    // The Positioned widget places the note at the stored coordinates
    return Positioned(
      left: _x,
      top: _y,
      // GestureDetector handles the dragging
      child: GestureDetector(
        onPanUpdate: (details) {
          // This updates the local position *while* dragging
          setState(() {
            _x += details.delta.dx;
            _y += details.delta.dy;
          });
        },
        onPanEnd: (details) {
          // IMPORTANT: When the drag stops, update Firebase
          _updatePositionInFirebase();
        },
        // The actual note card UI
        child: SizedBox(
          width: 150, // Fixed width for the card
          height: 150, // Fixed height for the card
          child: NoteCard(
            note: widget.note,
            isGrid: true, // Use a fixed card style
          ),
        ),
      ),
    );
  }
}