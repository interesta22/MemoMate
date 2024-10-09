import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_notes_app/core/helpers/extensions.dart';
import 'package:my_notes_app/core/helpers/sharedpref.dart';
import 'package:my_notes_app/core/helpers/spacing.dart';
import 'package:my_notes_app/core/routing/routs.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:my_notes_app/features/onboarding/ui/models/onboard_model.dart';
import 'package:my_notes_app/core/widgets/custom_button.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent(
      {super.key,
      required this.pageIndex,
      required this.list,
      required this.pageController});
  final int pageIndex;
  final List<OnboardModel> list;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 350.h,
            width: double.infinity,
            child: Image.asset(
              list[pageIndex].img,
            ),
          ),
          verticaalSpacing(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              list.length,
              (index) => Expanded(child: slide(isActive: index == pageIndex)),
            ),
          ),
          verticaalSpacing(50),
          Text(
            list[pageIndex].title1,
            style: FontsManager.font32BlackBold,
          ),
          Text(
            list[pageIndex].title2,
            style: FontsManager.font32BlackBold,
          ),
          verticaalSpacing(20),
          Text(
            list[pageIndex].subtitle,
            style: FontsManager.font15BlackRegular,
            textAlign: TextAlign.center,
          ),
          verticaalSpacing(30),
          pageIndex == 2
              ? CustomButton(
                  onPressed: () {
                    SharedprefHelper().setOnboardingSeen();
                    context.pushReplacementNamed(Routes.signupScreen);
                  },
                  buttonText: 'Get Started',
                  textStyle: FontsManager.font17WhiteMedium,
                )
              : Container(
                  height: 85,
                )
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class slide extends StatelessWidget {
  const slide({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.w, // حجم الشريط متغير
      height: 4.h,
      color: isActive ? ColorManager.mainblue : ColorManager.greylight,
    );
  }
}
