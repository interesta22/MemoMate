import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_notes_app/core/helpers/extensions.dart';
import 'package:my_notes_app/core/routing/app_router.dart';
import 'package:my_notes_app/core/routing/routs.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/features/onboarding/ui/models/onboard_model.dart';
import 'package:my_notes_app/features/onboarding/ui/screens/onboarding_content.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<OnboardModel> onboardList = [
    OnboardModel(
        img: 'assets/images/clip-1060.png',
        title1: 'Manage your',
        title2: 'notes easily',
        subtitle: 'A completely easy way to manage and customize your notes.'),
    OnboardModel(
        img: 'assets/images/clip-chatting-with-girlfriend 1.png',
        subtitle: 'A completely easy way to manage and customize your notes.',
        title1: 'Organize your',
        title2: 'thoughts'),
    OnboardModel(
        img: 'assets/images/clip-1026.png',
        subtitle:
            'Making your content legible has never been easier,Let\'s do it.',
        title1: 'Create cards and',
        title2: 'easy styling')
  ];

  int pageIndex = 0;
  late PageController _pagecontroller;

  @override
  void initState() {
    _pagecontroller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
              child: GestureDetector(
                onTap: () {
                  context.pushReplacementNamed(Routes.loginScreen);
                },
                child: Text(
                  'Skip',
                  style: FontsManager.font15BlueSemiBold,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                      onPageChanged: (index) {
                        setState(() {
                          pageIndex = index;
                        });
                      },
                      controller: _pagecontroller,
                      itemCount: onboardList.length,
                      itemBuilder: (context, index) => OnboardingContent(
                            pageController: _pagecontroller,
                            pageIndex: index,
                            list: onboardList,
                          )),
                ),
              ],
            ),
          ),
        ));
  }
}
