import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes_app/core/routing/routs.dart';
import 'package:my_notes_app/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:my_notes_app/features/sign_up/logic/signup%20cubit/signup_cubit.dart';
import 'package:my_notes_app/features/home/ui/screens/home_screen.dart';
import 'package:my_notes_app/features/login/ui/screens/login_screen.dart';
import 'package:my_notes_app/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:my_notes_app/features/sign_up/ui/screens/sign_up_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onBoardingScreen:
        return _buildCircularRevealRoute(OnboardingScreen(appRouter: AppRouter(),), settings);

      case Routes.homeScreen:
        return _buildCircularRevealRoute(HomeScreeen(), settings);

      case Routes.loginScreen:
        return _buildCircularRevealRoute(
          BlocProvider(
            create: (context) => LoginCubit(),
            child: LoginScreen(),
          ),
          settings,
        );

      case Routes.signupScreen:
        return _buildCircularRevealRoute(
          BlocProvider(
            create: (context) => SignupCubit(),
            child: SignupScreen(),
          ),
          settings,
        );

    }
    return null;
  }

  // Method to create a circular reveal route transition
  PageRouteBuilder _buildCircularRevealRoute(
      Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return CircularRevealTransition(
          animation: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(seconds: 1), // Set transition duration
      settings: settings,
    );
  }
}

// CircularRevealTransition widget
class CircularRevealTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const CircularRevealTransition({
    Key? key,
    required this.child,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final size = MediaQuery.of(context).size;
        final epicenter = Offset(size.width / 2, size.height / 2);
        final radius =
            sqrt(size.width * size.width + size.height * size.height);

        return ClipPath(
          clipper: CircularRevealClipper(
            fraction: animation.value,
            epicenter: epicenter,
            maxRadius: radius,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

// CircularRevealClipper for custom clipping
class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset epicenter;
  final double maxRadius;

  CircularRevealClipper({
    required this.fraction,
    required this.epicenter,
    required this.maxRadius,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = maxRadius * fraction;
    path.addOval(Rect.fromCircle(center: epicenter, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CircularRevealClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}
