import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_notes_app/core/helpers/extensions.dart';
import 'package:my_notes_app/core/helpers/spacing.dart';
import 'package:my_notes_app/core/routing/routs.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:my_notes_app/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:my_notes_app/features/settings/ui/screens/notifications.dart';
import 'package:my_notes_app/features/settings/ui/screens/edit_profile.dart';
import 'package:my_notes_app/features/settings/ui/widgets/setting_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    getUserData(); // تحميل البيانات عند بدء الشاشة
  }

  Future<void> getUserData() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>;
      });
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Deleting the account
        await user.delete();

        // Optionally, show a success dialog or navigate to the login screen
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: 'Success',
          desc: 'Your account has been deleted successfully.',
          btnOkOnPress: () {
            // Navigate to the login screen or home screen
            // Navigator.of(context).pushReplacementNamed('/login');
          },
          btnOkColor: Colors.green,
        ).show();
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific errors
      String errorMessage = 'Failed to delete account: ${e.message}';
      showErrorDialog(context, errorMessage);
    } catch (e) {
      // Handle other errors
      showErrorDialog(context, 'Failed to delete account. Please try again.');
    }
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: 'Error',
      desc: errorMessage,
      btnOkOnPress: () {
        Navigator.pop(context); // Close dialog
      },
      btnOkColor: Colors.red,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: ColorManager.backgroundcolor,
        body: userData == null
            ? SkeltonView()
            : buildBody(context),
      ),
    );
  }

  SafeArea buildBody(BuildContext context) {
    return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(right: 10.w, left: 20.w, top: 10.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Text(
                          'Profile',
                          style: FontsManager.font26BlackBold,
                        ),
                      ),
                      Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              userData?['img'] ??
                                  'https://w7.pngwing.com/pngs/831/88/png-transparent-user-profile-computer-icons-user-interface-mystique-miscellaneous-user-interface-design-smile.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                // إذا فشلت عملية تحميل الصورة، سيتم عرض دائرة رمادية
                                return ClipOval(
                                  child: Image.asset(
                                    'https://w7.pngwing.com/pngs/831/88/png-transparent-user-profile-computer-icons-user-interface-mystique-miscellaneous-user-interface-design-smile.png',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                          horizentalSpacing(20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData!['name'] ?? 'No Name',
                                style: FontsManager.font15BlackSemiBold,
                              ),
                              Text(
                                userData!['email'] ?? 'No Email',
                                style: FontsManager.font13GreyRegular,
                              ),
                            ],
                          )
                        ],
                      ),
                      verticaalSpacing(20),
                      SettingItem(
                        title: 'Edit profile',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()),
                          ).then((_) {
                            // إعادة تحميل البيانات بعد العودة
                            getUserData();
                          });
                        },
                      ),
                      verticaalSpacing(20),
                      SettingItem(
                          title: 'Notifications',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Notifications()),
                            ).then((_) {
                              // إعادة تحميل البيانات بعد العودة
                              getUserData();
                            });
                          }),
                      verticaalSpacing(20),
                      GestureDetector(
                        onTap: () {
                          AwesomeDialog(
                            buttonsTextStyle: FontsManager.font17WhiteMedium,
                            descTextStyle: FontsManager.font15BlackRegular,
                            titleTextStyle: FontsManager.font26BlackBold,
                            context: context,
                            animType: AnimType.bottomSlide,
                            dialogType: DialogType.infoReverse,
                            showCloseIcon: true,
                            title: 'Log out Confirmation',
                            desc: 'Are you sure you want to log out?',
                            btnOkOnPress: () {
                              BlocProvider.of<LoginCubit>(context).signOut();
                              context
                                  .pushReplacementNamed(Routes.loginScreen);
                            },
                            btnCancelText: 'No',
                            btnOkText: 'Yes',
                            btnCancelOnPress: () {},
                            btnCancelColor: ColorManager.mainblue,
                            btnOkColor: Colors.red,
                          ).show();
                        },
                        child: Text(
                          'Log out',
                          style: FontsManager.font15BlueBold,
                        ),
                      ),
                      verticaalSpacing(20),
                      GestureDetector(
                        onTap: () {
                          AwesomeDialog(
                            buttonsTextStyle: FontsManager.font17WhiteMedium,
                            descTextStyle: FontsManager.font15BlackRegular,
                            titleTextStyle: FontsManager.font26BlackBold,
                            context: context,
                            animType: AnimType.bottomSlide,
                            dialogType: DialogType.warning,
                            showCloseIcon: true,
                            title: 'Delete Account Confirmation',
                            desc:
                                'Are you sure you want to delete your account?',
                            btnOkOnPress: () async {
                              await deleteAccount(context);
                              AwesomeDialog(
                        buttonsTextStyle: FontsManager.font17WhiteMedium,
                        descTextStyle: FontsManager.font15BlackRegular,
                        titleTextStyle: FontsManager.font26BlackBold,
                        context: context,
                        animType: AnimType.bottomSlide,
                        dialogType: DialogType.success,
                        showCloseIcon: true,
                        title: 'Success',
                        desc: 'Account deleted successfully!',
                        btnOkOnPress: () {
                          context.pushReplacementNamed(Routes.loginScreen);
                        },
                        btnCancelText: 'No',
                        btnOkText: 'Yes',
                        btnCancelOnPress: () {},
                        btnCancelColor: ColorManager.mainblue,
                        btnOkColor: Colors.red,
                      ).show();
                            },
                            btnCancelText: 'Cancel',
                            btnOkText: 'Confirm',
                            btnCancelOnPress: () {},
                            btnCancelColor: ColorManager.mainblue,
                            btnOkColor: Colors.red,
                          ).show();
                        },
                        child: Text(
                          'Delete account',
                          style: FontsManager.font15RedBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
  }
}

class SkeltonView extends StatelessWidget {
  const SkeltonView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Skeletonizer(
          child: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.only(right: 10.w, left: 20.w, top: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      'Profile',
                      style: FontsManager.font26BlackBold,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(32)),
                      ),
                      horizentalSpacing(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.grey[400],
                            width: 150.w,
                            height: 15.h,
                          ), // الاسم الوهمي
                          SizedBox(height: 10.h),
                          Container(
                            color: Colors.grey[400],
                            width: 200.w,
                            height: 13.h,
                          ), // البريد الوهمي
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Container(
                    color: Colors.grey[400],
                    width: double.infinity,
                    height: 50.h,
                  ), // إعدادات وهمية
                  SizedBox(height: 20.h),
                  Container(
                    color: Colors.grey[400],
                    width: double.infinity,
                    height: 50.h,
                  ), // إعدادات وهمية
                  SizedBox(height: 20.h),
                  Container(
                    color: Colors.grey[400],
                    width: double.infinity,
                    height: 50.h,
                  ), // إعدادات وهمية
                ],
              ),
            ),
          ),
        ),
      );
  }
}
