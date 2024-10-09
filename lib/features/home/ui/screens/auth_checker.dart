import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:my_notes_app/features/home/ui/screens/home_screen.dart';
import 'package:my_notes_app/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:my_notes_app/features/login/ui/screens/login_screen.dart';

class AuthChecker extends StatefulWidget {
  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _showLottie = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _showLottie = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return StreamBuilder<User?>(
          stream: context.read<LoginCubit>().authStateChanges(),
          builder: (context, snapshot) {
            if (_showLottie) {
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

            if (snapshot.hasData) {
              return const HomeScreeen();
            }

            return const LoginScreen();
          },
        );
      },
    );
  }
}
