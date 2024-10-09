import 'package:flutter/material.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/core/utils/colors.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const SettingItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: FontsManager.font15DarkBlackBold),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: ColorManager.black,
            size: 18,
          )
        ],
      ),
    );
  }
}
