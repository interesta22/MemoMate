import 'package:flutter/material.dart';
import 'package:my_notes_app/core/utils/fonts.dart';

class RichText1 extends StatelessWidget {
  const RichText1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: 'By logging to agree to our',
              style: FontsManager.font13GreyLight),
          TextSpan(
              text: ' Terms & Conditions',
              style: FontsManager.font13DarkBlueMedium),
          TextSpan(
              text: ' and',
              style: FontsManager.font13GreyLight.copyWith(height: 1.5)),
          TextSpan(
              text: ' Privacy Policy.',
              style: FontsManager.font13DarkBlueMedium),
        ]));
  }
}
