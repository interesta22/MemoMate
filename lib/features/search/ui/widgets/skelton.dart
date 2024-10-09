import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoteCardSkeleton extends StatelessWidget {
  const NoteCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 20.h,
            color: Colors.grey[400],
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            height: 15.h,
            color: Colors.grey[400],
          ),
          SizedBox(height: 10.h),
          Container(
            width: 100.w,
            height: 15.h,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
