import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'add_note_state.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AddNoteCubit() : super(AddNoteInitial());

  Future<void> saveNote() async {
    emit(AddNoteLoading()); // Emit loading state
    String titleText = titleController.text.trim();
    String noteText = noteController.text.trim();

    // Check if both the title and note are not empty
    if (titleText.isNotEmpty && noteText.isNotEmpty) {
      String uid = _auth.currentUser!.uid; // Get current user UID

      try {
        // Add the note to Firestore with isFavorite set to false
        await _firestore.collection('notes').add({
          'userId': uid,
          'title': titleText,
          'note': noteText,
          'createdAt': Timestamp.now(),
          'isFavorite': false, // Default value for new notes
        });

        titleController.clear();
        noteController.clear(); // Clear input fields after saving
        emit(AddNoteSuccess()); // Emit success state
      } catch (e) {
        emit(AddNoteFailure(errorMessage: e.toString())); // Emit error state
      }
    } else {
      emit(AddNoteFailure(
          errorMessage:
              'Title and note content cannot be empty.')); // Emit error if empty
    }
  }
}
