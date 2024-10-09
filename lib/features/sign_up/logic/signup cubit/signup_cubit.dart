import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<User?> signup(
      {required String email, required String password, required String name, required String? img}) async {
    emit(SignupLoading());
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set({'name': name, 'email': email, 'password': password, 'img': img});
      emit(SignupSuccess());
      return credential.user;
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      emit(SignupFailure(errorMessage: e.message.toString()));
    } catch (e) {
      log('Unexpected error: $e');
      emit(SignupFailure(errorMessage: 'An unexpected error occurred.'));
    }
    return null;
  }
  Future<String?> uploadProfileImage(_profileImage) async {
    if (_profileImage != null) {
      try {
        String fileName =
            'profile_images/${DateTime.now().millisecondsSinceEpoch}.png';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(_profileImage!);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();
        return imageUrl;
      } catch (e) {
        print('Error uploading image: $e');
        return null;
      }
    }
    return null;
  }
}
