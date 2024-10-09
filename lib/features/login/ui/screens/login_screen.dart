import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_notes_app/core/helpers/extensions.dart';
import 'package:my_notes_app/core/helpers/spacing.dart';
import 'package:my_notes_app/core/routing/routs.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:my_notes_app/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:my_notes_app/core/widgets/custom_text_field.dart';
import 'package:my_notes_app/core/widgets/custom_button.dart';
import 'package:my_notes_app/features/login/ui/widgets/rich_text_1.dart';
import 'package:my_notes_app/features/login/ui/widgets/rich_text_2.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool isObsecureText = true;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is LoginSuccess) {
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
            desc: 'You logged in successfully!',
            btnOkOnPress: () {
              context.pushReplacementNamed(Routes.homeScreen);
            },
            btnOkColor: ColorManager.mainblue,
          ).show();
        } else if (state is LoginFailure) {
          setState(() {
            isLoading = false;
          });
          AwesomeDialog(
                  buttonsTextStyle: FontsManager.font17WhiteMedium,
                  descTextStyle: FontsManager.font15BlackRegular,
                  titleTextStyle: FontsManager.font26BlackBold,
                  context: context,
                  animType: AnimType.bottomSlide,
                  dialogType: DialogType.error,
                  showCloseIcon: true,
                  title: 'Failed',
                  desc: state.errorMessage,
                  btnOkOnPress: () {},
                  btnOkColor: ColorManager.mainblue)
              .show();
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
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); // إلغاء التركيز عند النقر بالخارج
            },
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back',
                        style: FontsManager.font24BlueBold,
                      ),
                      verticaalSpacing(8),
                      Text(
                        'We\'re excited to have you back, can\'t wait to see what you\'ve been up to since you last logged in!',
                        style: FontsManager.font13DarkBlueRegular,
                      ),
                      verticaalSpacing(36),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              backgroundColor: ColorManager.backgroundcolor,
                              hintText: 'Email',
                              isObsecure: false,
                            ),
                            verticaalSpacing(15),
                            CustomTextField(
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              backgroundColor: ColorManager.backgroundcolor,
                              hintText: 'Password',
                              isObsecure: isObsecureText,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isObsecureText = !isObsecureText;
                                  });
                                },
                                icon: isObsecureText
                                    ? const Icon(Icons.visibility_off_outlined)
                                    : const Icon(Icons.visibility_outlined),
                              ),
                            ),
                            verticaalSpacing(15),
                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Text(
                                'Forgot Password?',
                                style: FontsManager.font13BlueSemiBold,
                              ),
                            ),
                            verticaalSpacing(30),
                            CustomButton(
                              buttonText: 'Login',
                              textStyle: FontsManager.font17WhiteMedium,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  BlocProvider.of<LoginCubit>(context).login(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                            ),
                            verticaalSpacing(15),
                            const RichText1(),
                            verticaalSpacing(30),
                            RichText2(
                              quiz: 'Don\'t have an account?',
                              rout: ' Sign Up',
                              onTap: () {
                                context
                                    .pushReplacementNamed(Routes.signupScreen);
                              },
                            ),
                          ],
                        ),
                      ),
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
}
