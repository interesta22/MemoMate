part of 'notes_cubit_cubit.dart';

sealed class NotesState {}

final class NotesInitial extends NotesState {}
final class NotesLoading extends NotesState {}
final class NotesLoaded extends NotesState {
  final List<NoteModel> notes;
  NotesLoaded(this.notes);
}
final class NotesFailure extends NotesState {
  String errorMessage;
  NotesFailure({required this.errorMessage});
}
