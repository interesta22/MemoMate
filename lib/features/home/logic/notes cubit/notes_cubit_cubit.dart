import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes_app/features/home/data/models/note_model.dart';

part 'notes_cubit_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> fetchNotes(String userId) async {
    emit(NotesLoading());
    try {
      final notesSnapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .get();

      List<NoteModel> notes =
          notesSnapshot.docs.map((doc) => NoteModel.fromFirestore(doc)).toList();

      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesFailure(errorMessage:  'Failed to fetch notes: ${e.toString()}'));
    }
  }
  
}
