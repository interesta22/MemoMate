import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_notes_app/core/utils/colors.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final double? horizentalPadding;
  final double? verticalPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final String buttonText;
  final TextStyle textStyle;
  final VoidCallback onPressed;

  const CustomButton({super.key, this.borderRadius, this.backgroundColor, this.horizentalPadding, this.verticalPadding, this.buttonWidth, this.buttonHeight, required this.buttonText, required this.textStyle, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 16)
          )
        ),
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor ?? ColorManager.mainblue
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: horizentalPadding?.w ?? 12.w, vertical: verticalPadding?.h ?? 14.h),
        ),
        fixedSize: WidgetStateProperty.all(
          Size(buttonWidth?.w ?? double.maxFinite, buttonHeight?.h ?? 50.h),
        ),

      ),
      onPressed: onPressed,
      child: Text(buttonText, style: textStyle,),
    );
  }
}
