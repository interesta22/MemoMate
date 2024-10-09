import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:my_notes_app/features/create_note/logic/add_note_cubit.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  bool isLoading = false;

  

  void _saveNote() async {
  // تحقق من الاتصال قبل الحفظ
    // هنا يمكنك استدعاء وظيفة حفظ الملاحظة وانتظارها
    await BlocProvider.of<AddNoteCubit>(context).saveNote();
}


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNoteCubit(),
      child: BlocConsumer<AddNoteCubit, AddNoteState>(
        listener: (context, state) {
          if (state is AddNoteLoading) {
            setState(() {
              isLoading = true;
            });
          } 
          else if (state is AddNoteSuccess) {
            setState(() {
              isLoading = false;
            });
            AwesomeDialog(
              buttonsTextStyle: FontsManager.font17WhiteMedium,
              descTextStyle: FontsManager.font15BlackRegular,
              titleTextStyle: FontsManager.font26BlackBold,
              context: context,
              animType: AnimType.bottomSlide,
              dialogType: DialogType.success,
              showCloseIcon: true,
              title: 'Success',
              desc: 'Note saved successfully!',
              btnOkOnPress: () {},
              btnOkColor: ColorManager.mainblue,
            ).show();
          } else if (state is AddNoteFailure) {
            setState(() {
              isLoading = false;
            });
            AwesomeDialog(
              buttonsTextStyle: FontsManager.font17WhiteMedium,
              descTextStyle: FontsManager.font15BlackRegular,
              titleTextStyle: FontsManager.font26BlackBold,
              context: context,
              animType: AnimType.bottomSlide,
              dialogType: DialogType.warning,
              showCloseIcon: true,
              title: 'Warning',
              desc: state.errorMessage,
              btnOkOnPress: () {},
              btnOkColor: ColorManager.mainblue,
            ).show();
          }
        },
        builder: (context, state) {
          final cubit = BlocProvider.of<AddNoteCubit>(context);
          return Scaffold(
            body: ModalProgressHUD(
              progressIndicator: CircularProgressIndicator(
                backgroundColor: ColorManager.mainblue.withOpacity(0.2),
                color: ColorManager.mainblue,
                strokeWidth: 5,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              opacity: 0.1,
              inAsyncCall: isLoading,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 20.h),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Create Note',
                                style: FontsManager.font26BlackBold,
                              ),
                              GestureDetector(
                                onTap: () {
                                  cubit.saveNote();
                                },
                                child: Container(
                                  height: 30.h,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                      color: ColorManager.mainblue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      'Save',
                                      style: FontsManager.font15WhiteRegular,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        TextField(
                          
                          controller: cubit.titleController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Note Title',
                              hintStyle: FontsManager.font22GreyBold),
                          style: TextStyle(fontSize: 22.sp),
                        ),
                        TextField(
                          controller: cubit.noteController,
                          decoration: InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              hintText: 'Note Content',
                              hintStyle: FontsManager.font15GreysemiBold),
                          maxLines: null,
                          style: TextStyle(fontSize: 17.sp),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
