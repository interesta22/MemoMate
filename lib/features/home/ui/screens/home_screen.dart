import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:my_notes_app/features/home/logic/delete%20notes%20cubit/delete_notes_cubit.dart';
import 'package:my_notes_app/features/home/logic/nav%20bar%20cubit/bottom_vav_cubit_cubit.dart';
import 'package:my_notes_app/features/home/logic/notes%20cubit/notes_cubit_cubit.dart';
import 'package:my_notes_app/features/login/logic/login%20cubit/login_cubit.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../create_note/ui/screens/create_note.dart';
import 'notes_screen.dart';
import '../../../search/ui/screens/search_screen.dart';
import '../../../settings/ui/screens/settings_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreeen extends StatefulWidget {
  const HomeScreeen({super.key});

  @override
  _HomeScreeenState createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  final PageController _pageController =
      PageController(); 

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotesCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(create: (context) => DeleteNotesCubit()),
      ],
      child: Scaffold(
        body: BlocBuilder<BottomNavCubit, int>(
          builder: (context, currentIndex) {
            return PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                context
                    .read<BottomNavCubit>()
                    .changeTab(index); 
              },
              children: const [
                NotesScreen(),
                SettingsScreen(),
                SearchScreen(),
                CreateNoteScreen(),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
          builder: (context, currentIndex) {
            return SalomonBottomBar(
              backgroundColor: ColorManager.backgroundcolor,
              selectedItemColor: ColorManager.mainblue,
              unselectedItemColor: const Color(0xff757575),
              currentIndex: currentIndex, 
              onTap: (index) {
                _pageController
                    .jumpToPage(index); 
                context.read<BottomNavCubit>().changeTab(index);
              },
              items: [
                SalomonBottomBarItem(
                  icon: const Icon(HugeIcons.strokeRoundedNote01),
                  title: const Text(
                    'Notes',
                    style: TextStyle(fontFamily: 'Inter'),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(HugeIcons.strokeRoundedUser),
                  title: const Text(
                    'Profile',
                    style: TextStyle(fontFamily: 'Inter'),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(HugeIcons.strokeRoundedSearch01),
                  title: const Text(
                    'Search',
                    style: TextStyle(fontFamily: 'Inter'),
                  ),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(HugeIcons.strokeRoundedNoteAdd),
                  title: const Text(
                    'Create',
                    style: TextStyle(fontFamily: 'Inter'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
