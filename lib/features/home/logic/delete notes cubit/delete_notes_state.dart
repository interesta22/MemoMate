part of 'delete_notes_cubit.dart';


sealed class DeleteState {}

final class DeleteInitial extends DeleteState {}
final class DeleteLoading extends DeleteState {}
final class DeleteSuccess extends DeleteState {}
final class DeleteFailure extends DeleteState {
  String errorMessage;
  DeleteFailure({required this.errorMessage});
}

