import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final int position; // Crucial for ordering/reordering
  final DateTime createdAt;
  final double x; // X-coordinate for screen position
  final double y;
  final bool isPinned;
  
  // 1. NEW FIELD: Add the boolean flag for archiving
  final bool isArchived; 

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.position,
    required this.createdAt,
    required this.x,
    required this.y,
    // 2. REQUIRED IN CONSTRUCTOR: Default it to false if not provided
    this.isArchived = false, 
    this.isPinned = false,
  });

  // Factory constructor to create a Note from a Firestore DocumentSnapshot
  factory Note.fromFirestore(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      position: data['position'] ?? 0,
      x: (data['x'] as num?)?.toDouble() ?? 0.0,
      y: (data['y'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),

      isArchived: data['isArchived'] ?? false,
      isPinned: data['isPinned'] ?? false, 
    );
  }

  // Convert Note to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'position': position,
      'x': x,
      'y': y,
      'createdAt': Timestamp.fromDate(createdAt),
      
      // 4. WRITE TO FIREBASE: Include the 'isArchived' field when saving
      'isArchived': isArchived,
      'isPinned': isPinned, 
    };
  }
}