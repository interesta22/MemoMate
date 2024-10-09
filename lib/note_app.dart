import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:my_notes_app/core/helpers/sharedpref.dart';
import 'package:my_notes_app/core/routing/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:my_notes_app/features/home/ui/screens/auth_checker.dart';
import 'package:my_notes_app/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:my_notes_app/features/onboarding/ui/screens/onboarding_screen.dart';

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _buildAppTheme(),
        onGenerateRoute: AppRouter().generateRoute,
        home: _buildHome(),
      ),
    );
  }

  // Extracted method for creating the theme
  ThemeData _buildAppTheme() {
    return ThemeData(
      primaryColor: ColorManager.mainblue,
      scaffoldBackgroundColor: ColorManager.backgroundcolor,
      secondaryHeaderColor: ColorManager.backgroundcolor,
    );
  }

  // Method to build the home based on onboarding status
  Widget _buildHome() {
    return FutureBuilder<bool>(
      future: SharedprefHelper().checkOnboarding(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingIndicator();
        }

        if (snapshot.hasData && snapshot.data == true) {
          return BlocProvider(
            create: (context) => LoginCubit(),
            child: AuthChecker(),
          );
        } else {
          return OnboardingScreen(appRouter: AppRouter());
        }
      },
    );
  }
}

// Extracted loading indicator widget for better code readability
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'lib/core/utils/animations/Animation - 1727984786671.json',
          repeat: true,
          frameRate: FrameRate.max,
        ),
      ),
    );
  }
}
