import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_notes_app/core/helpers/sharedpref.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      // Attempt to log in using Firebase Auth
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Successful login, save login status to SharedPreferences
      await SharedprefHelper().setLoginStatus(true);
      emit(LoginSuccess());

      return credential.user;
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(errorMessage: e.message.toString()));
      log(e.toString());
    }
    return null;
  }

  Future<void> signOut() async {
    // Attempt to sign out
    await SharedprefHelper().setLoginStatus(false); // Mark user as logged out
    await _auth.signOut();
  }

  // Check auth state (Stream to listen for auth changes)
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
