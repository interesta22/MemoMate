import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_notes_app/core/helpers/spacing.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:my_notes_app/core/widgets/custom_button.dart';
import 'package:my_notes_app/core/widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isObsecureText = true;
  bool _isLoading = false; // Add a loading state
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? _profileImage;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final String uid = _auth.currentUser!.uid;
    final DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();

    if (userDoc.exists) {
      final Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;
      setState(() {
        nameController.text = userData['name'] ?? '';
        emailController.text = userData['email'] ?? '';
        passwordController.text = userData['password'] ?? '';
        _profileImageUrl = userData['img'];
      });
    }
  }

  Future<void> _saveProfile() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _isLoading = true; // Show loading
      });
      try {
        if (_profileImage != null) {
          final String fileName = 'profile_${user.uid}.jpg';
          final UploadTask uploadTask =
              _storage.ref('profile_images/$fileName').putFile(_profileImage!);
          final TaskSnapshot snapshot = await uploadTask;
          _profileImageUrl = await snapshot.ref.getDownloadURL();
        }

        await _firestore.collection('users').doc(user.uid).update({
          'name': nameController.text,
          'img': _profileImageUrl,
        });

        _showSuccessDialog();
      } on FirebaseAuthException catch (e) {
        _showErrorDialog(e.message.toString());
      } catch (e) {
        _showErrorDialog('Failed to update profile. Please try again.');
      } finally {
        setState(() {
          _isLoading = false; // Hide loading
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _showSuccessDialog() {
    AwesomeDialog(
      buttonsTextStyle: FontsManager.font17WhiteMedium,
      descTextStyle: FontsManager.font15BlackRegular,
      titleTextStyle: FontsManager.font26BlackBold,
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Success',
      desc: 'Changes saved successfully!',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
      btnOkColor: ColorManager.mainblue,
    ).show();
  }

  void _showErrorDialog(String errorMessage) {
    AwesomeDialog(
      buttonsTextStyle: FontsManager.font17WhiteMedium,
      descTextStyle: FontsManager.font15BlackRegular,
      titleTextStyle: FontsManager.font26BlackBold,
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.error,
      showCloseIcon: true,
      title: 'Failed',
      desc: errorMessage,
      btnOkOnPress: () {
        Navigator.pop(context);
      },
      btnOkColor: ColorManager.mainblue,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          backgroundColor: ColorManager.mainblue.withOpacity(0.2),
          color: ColorManager.mainblue,
          strokeWidth: 5,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        opacity: 0.1,
        inAsyncCall: _isLoading, // Show loader based on loading state
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(right: 10.w, left: 20.w, top: 30.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Edit Profile',
                          style: FontsManager.font26BlackBold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : null,
                        backgroundColor: Colors.grey[300],
                        child: _profileImage == null && _profileImageUrl == null
                            ? Icon(Icons.camera_alt,
                                size: 50.sp, color: Colors.grey[700])
                            : null,
                      ),
                    ),
                    verticaalSpacing(10),
                    CustomTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      controller: nameController,
                      backgroundColor: ColorManager.backgroundcolor,
                      hintText: 'Full name',
                      isObsecure: false,
                    ),
                    verticaalSpacing(15),
                    CustomTextField(
                      validator: (value){},
                      isEnabled: false,
                      controller: emailController,
                      backgroundColor: ColorManager.backgroundcolor,
                      hintText: 'Email',
                      isObsecure: false,
                    ),
                    verticaalSpacing(15),
                    CustomTextField(
                      validator: (value){},
                      isEnabled: false,
                      controller: passwordController,
                      backgroundColor: ColorManager.backgroundcolor,
                      hintText: 'Password',
                      isObsecure: false,
                    ),
                    verticaalSpacing(20),
                    CustomButton(
                      buttonText: 'Save',
                      textStyle: FontsManager.font17WhiteMedium,
                      onPressed: _saveProfile,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
