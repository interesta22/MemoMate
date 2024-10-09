import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:my_notes_app/core/utils/fonts.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 10.w, left: 20.w, top: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Text(
                  'Notifications',
                  style: FontsManager.font26BlackBold,
                ),
              ),
              Expanded(
                // Makes the content expand to fill the available vertical space
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Ionicons.notifications_outline,
                          size: 100.sp, color: Colors.grey),
                      SizedBox(
                          height: 20
                              .h), // Adds some space between the icon and the text
                      Text(
                        'Empty',
                        style: FontsManager.font26BlackBold
                            .copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
