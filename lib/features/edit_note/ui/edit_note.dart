import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_notes_app/core/helpers/spacing.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:my_notes_app/core/widgets/custom_button.dart';
import 'package:my_notes_app/features/home/data/models/note_model.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({super.key, required this.note});
  final NoteModel note;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  bool isLoading = false;
  late TextEditingController titleController;
  late TextEditingController noteController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void showAwesomeDialog({
    required DialogType dialogType,
    required String title,
    required String description,
    VoidCallback? onOkPress,
  }) {
    AwesomeDialog(
      buttonsTextStyle: FontsManager.font17WhiteMedium,
      descTextStyle: FontsManager.font15BlackRegular,
      titleTextStyle: FontsManager.font26BlackBold,
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: dialogType,
      showCloseIcon: true,
      title: title,
      desc: description,
      btnOkOnPress: onOkPress,
      btnOkColor: ColorManager.mainblue,
    ).show();
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    noteController = TextEditingController(text: widget.note.note);
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void saveNote() async {
    if (titleController.text.trim().isEmpty ||
        noteController.text.trim().isEmpty) {
      showAwesomeDialog(
        dialogType: DialogType.warning,
        title: 'Warning',
        description: 'Note cannot be empty.',
        onOkPress: (){}
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('notes').doc(widget.note.id).update({
          'title': titleController.text.trim(),
          'note': noteController.text.trim(),
        });

        showAwesomeDialog(
          dialogType: DialogType.success,
          title: 'Success',
          description: 'Changes saved successfully!',
          onOkPress: () {
            Navigator.pop(context);
          },
        );
      } on Exception catch (e) {
        showAwesomeDialog(
          dialogType: DialogType.error,
          title: 'Failed',
          description: e.toString(),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        backgroundColor: ColorManager.mainblue.withOpacity(0.2),
        color: ColorManager.mainblue,
        strokeWidth: 5,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      opacity: 0.1,
      inAsyncCall: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(right: 10.w, left: 20.w, top: 10.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      'Edit Note',
                      style: FontsManager.font26BlackBold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Note Title',
                        hintStyle: FontsManager.font22GreyBold,
                      ),
                      style: TextStyle(fontSize: 22.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: 'Note Content',
                        hintStyle: FontsManager.font15GreysemiBold,
                      ),
                      maxLines: null,
                      style: TextStyle(fontSize: 17.sp),
                    ),
                  ),
                  verticaalSpacing(20),
                  CustomButton(buttonText: 'Save', textStyle: FontsManager.font17WhiteMedium, onPressed: saveNote)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
