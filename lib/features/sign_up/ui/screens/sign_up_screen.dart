import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_notes_app/core/helpers/extensions.dart';
import 'package:my_notes_app/core/helpers/spacing.dart';
import 'package:my_notes_app/core/routing/routs.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:my_notes_app/features/sign_up/logic/signup%20cubit/signup_cubit.dart';
import 'package:my_notes_app/core/widgets/custom_button.dart';
import 'package:my_notes_app/core/widgets/custom_text_field.dart';
import 'package:my_notes_app/features/login/ui/widgets/rich_text_1.dart';
import 'package:my_notes_app/features/login/ui/widgets/rich_text_2.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isObsecureText = true;
  File? _profileImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupCubit = BlocProvider.of<SignupCubit>(context);

    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is SignupSuccess) {
          setState(() {
            isLoading = false;
          });
          _showSuccessDialog(context);
        } else if (state is SignupFailure) {
          setState(() {
            isLoading = false;
          });
          _showErrorDialog(context, state.errorMessage);
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.backgroundcolor,
        body: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(
            backgroundColor: ColorManager.mainblue.withOpacity(0.2),
            color: ColorManager.mainblue,
            strokeWidth: 5,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          opacity: 0.1,
          inAsyncCall: isLoading,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(right: 30.w, left: 30.w, top: 30.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeText(),
                      verticaalSpacing(36),
                      _buildSignupForm(signupCubit),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to MemoMate!',
          style: FontsManager.font24BlueBold,
        ),
        verticaalSpacing(8),
        Text(
          'We’re excited to have you join us in organizing your thoughts and capturing your ideas effortlessly. With My Notes, you can keep track of your ideas, tasks, and daily plans all in one place, accessible anytime and anywhere.',
          style: FontsManager.font13DarkBlueRegular,
        ),
      ],
    );
  }

  Widget _buildSignupForm(SignupCubit signupCubit) {
    return Form(
      key: signupCubit.formKey,
      child: Column(
        children: [
          GestureDetector(
            onTap: pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
              backgroundColor: Colors.grey[300],
              child: _profileImage == null
                  ? Icon(Icons.camera_alt, size: 50.sp, color: Colors.grey[700])
                  : null,
            ),
          ),
          verticaalSpacing(20),
          CustomTextField(
            controller: signupCubit.nameController,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your name' : null,
            backgroundColor: ColorManager.backgroundcolor,
            hintText: 'Full name',
            isObsecure: false,
          ),
          verticaalSpacing(15),
          CustomTextField(
            controller: signupCubit.emailController,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter a valid email' : null,
            backgroundColor: ColorManager.backgroundcolor,
            hintText: 'Email',
            isObsecure: false,
          ),
          verticaalSpacing(15),
          CustomTextField(
            controller: signupCubit.passwordController,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter your password' : null,
            backgroundColor: ColorManager.backgroundcolor,
            hintText: 'Password',
            isObsecure: isObsecureText,
            suffixIcon: IconButton(
              onPressed: () => setState(() => isObsecureText = !isObsecureText),
              icon: Icon(isObsecureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
            ),
          ),
          verticaalSpacing(15),
          CustomTextField(
            controller: signupCubit.confirmPasswordController,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Please confirm your password';
              if (value != signupCubit.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            backgroundColor: ColorManager.backgroundcolor,
            hintText: 'Confirm your password',
            isObsecure: isObsecureText,
            suffixIcon: IconButton(
              onPressed: () => setState(() => isObsecureText = !isObsecureText),
              icon: Icon(isObsecureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
            ),
          ),
          verticaalSpacing(30),
          CustomButton(
            buttonText: 'Sign up',
            textStyle: FontsManager.font17WhiteMedium,
            onPressed: () async {
              if (signupCubit.formKey.currentState?.validate() ?? false) {
                signupCubit.signup(
                  img: await signupCubit.uploadProfileImage(_profileImage),
                  name: signupCubit.nameController.text,
                  email: signupCubit.emailController.text,
                  password: signupCubit.passwordController.text,
                );
              }
            },
          ),
          verticaalSpacing(15),
          const RichText1(),
          verticaalSpacing(30),
          RichText2(
            quiz: 'Already have an account?',
            rout: ' Login',
            onTap: () => context.pushReplacementNamed(Routes.loginScreen),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      buttonsTextStyle: FontsManager.font17WhiteMedium,
      descTextStyle: FontsManager.font15BlackRegular,
      titleTextStyle: FontsManager.font26BlackBold,
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Success',
      desc: 'You signed in successfully!',
      btnOkOnPress: () {
        context.pushReplacementNamed(Routes.homeScreen);
      },
      btnOkColor: ColorManager.mainblue,
    ).show();
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
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
      btnOkOnPress: () {},
      btnOkColor: ColorManager.mainblue,
    ).show();
  }
}
