import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_notes_app/core/utils/fonts.dart';

class RichText2 extends StatelessWidget {
  final String quiz;
  final String rout;
  final VoidCallback onTap;

  const RichText2({
    super.key,
    required this.quiz,
    required this.rout,
    required this.onTap, // Callback for handling route actions
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: quiz,
            style: FontsManager.font13GreyLight,
          ),
          TextSpan(
            text: rout,
            style: FontsManager.font13BlueSemiBold,
            recognizer: TapGestureRecognizer()
              ..onTap = onTap, // Trigger the passed callback
          ),
        ],
      ),
    );
  }
}
