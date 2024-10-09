import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String note;
  final Timestamp createdAt;
  bool isFavorite; // This should be mutable

  NoteModel({
    required this.id,
    required this.title,
    required this.note,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      title: data['title'],
      note: data['note'],
      createdAt: data['createdAt'],
      isFavorite: data['isFavorite'] ??
          false, // Load from Firestore, default to false if not present
    );
  }

  // Method to toggle favorite status
  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
