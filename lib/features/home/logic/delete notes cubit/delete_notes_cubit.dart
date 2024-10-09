import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes_app/features/home/data/models/note_model.dart';

part 'delete_notes_state.dart';

class DeleteNotesCubit extends Cubit<DeleteState> {
  DeleteNotesCubit() : super(DeleteInitial());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // دالة لحذف الملاحظات المختارة
  Future<void> deleteNotes(List<NoteModel> selectedNotes) async {
    try {
      emit(DeleteLoading());
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // حذف كل الملاحظات المختارة من Firestore
      for (var note in selectedNotes) {
        await firestore.collection('notes').doc(note.id).delete();
      }

      emit(DeleteSuccess());
    } catch (e) {
      emit(DeleteFailure(errorMessage: e.toString()));
    }
  }
}
