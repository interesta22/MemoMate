import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:my_notes_app/core/helpers/spacing.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:ionicons/ionicons.dart';
import 'package:my_notes_app/core/widgets/note_card.dart';
import 'package:my_notes_app/features/edit_note/ui/edit_note.dart';
import 'package:my_notes_app/features/home/data/models/note_model.dart';
import 'package:my_notes_app/features/home/logic/delete%20notes%20cubit/delete_notes_cubit.dart';
import 'package:my_notes_app/features/home/logic/notes%20cubit/notes_cubit_cubit.dart';
import 'package:my_notes_app/features/home/ui/screens/favorites.dart';
import 'package:my_notes_app/features/search/ui/widgets/skelton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool isLoading = false;
  bool isSelecting = false; // Selection state
  final userId = FirebaseAuth.instance.currentUser!.uid;
  List<NoteModel> selectedNotes = [];
  String searchQuery = ""; // New variable to hold search query
  List<NoteModel> allNotes = []; // To store all notes for filtering

  // Activate or deactivate note selection
  void toggleSelect(NoteModel note) {
    setState(() {
      if (selectedNotes.contains(note)) {
        selectedNotes.remove(note); // Deselect
      } else {
        selectedNotes.add(note); // Select
      }

      // If no notes are selected, exit selection mode
      if (selectedNotes.isEmpty) {
        isSelecting = false;
      }
    });
  }

  void startSelecting() {
    setState(() {
      isSelecting = true;
    });
  }

  Future<void> deleteSelectedNotes() async {
    setState(() {
      isLoading = true; // قم بتعيين حالة التحميل
    });

    try {
      for (NoteModel note in selectedNotes) {
        await FirebaseFirestore.instance
            .collection('notes')
            .doc(note.id)
            .delete();
      }
      setState(() {
        isLoading = false; // قم بإيقاف حالة التحميل
        selectedNotes.clear(); // مسح الملاحظات المحددة
        isSelecting = false; // إنهاء وضع التحديد بعد الحذف
      });
      await context
          .read<NotesCubit>()
          .fetchNotes(userId); // تحديث قائمة الملاحظات
    } catch (e) {
      setState(() {
        isLoading = false; // قم بإيقاف حالة التحميل في حالة الخطأ
      });
    }
  }


  void showAwesomeDialog({
    required DialogType dialogType,
    required String title,
    required String description,
    VoidCallback? onOkPress,
  }) {
    AwesomeDialog(
      buttonsTextStyle: FontsManager.font17WhiteMedium,
      descTextStyle: FontsManager.font15BlackRegular,
      titleTextStyle: FontsManager.font26BlackBold,
      context: context,
      animType: AnimType.bottomSlide,
      dialogType: dialogType,
      showCloseIcon: true,
      title: title,
      desc: description,
      btnOkOnPress: onOkPress,
      btnOkColor: ColorManager.mainblue,
    ).show();
  }

  void _showDeleteConfirmationDialog() {
    showAwesomeDialog(
      dialogType: DialogType.warning,
      title: 'Confirm Delete',
      description: 'Are you sure you want to delete the selected notes?',
      onOkPress: () {
        deleteSelectedNotes();
      },
    );
  }
  void toggleFavoriteStatus(NoteModel note) {
    setState(() {
      note.isFavorite = !note.isFavorite; // Toggle favorite status
    });

    // Update the note in Firestore
    FirebaseFirestore.instance.collection('notes').doc(note.id).update({
      'isFavorite': note.isFavorite,
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<NotesCubit>().fetchNotes(userId);
  }

  @override
  void initState() {
    super.initState();
    // Fetch notes when the screen initializes
    context.read<NotesCubit>().fetchNotes(userId);
  }

  void _searchNotes(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  // دالة لتحديث الملاحظات
  Future<void> _refreshNotes() async {
    context.read<NotesCubit>().fetchNotes(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and date header
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: selectedNotes.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notes',
                            style: FontsManager.font26BlackBold,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                            create: (context) => NotesCubit(),
                                            child: FavoritesNotesScreen(),
                                          )));
                            },
                            icon: Icon(Ionicons.heart_outline),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Center(
                              child: Text(
                                '${selectedNotes.length} item selected',
                                style: FontsManager.font26BlackBold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _showDeleteConfirmationDialog,
                            icon: Icon(
                              HugeIcons.strokeRoundedDelete02,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
              ),
              // Search box
              CupertinoSearchTextField(
                prefixInsets: EdgeInsets.symmetric(horizontal: 15),
                placeholderStyle: FontsManager.font18GreyRegular,
                style: FontsManager.font15BlackRegular,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                onChanged: _searchNotes, // Update the search query
              ),
              verticaalSpacing(20),
              Text(
                'Recent Notes',
                style: FontsManager.font15DarkBlackBold,
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: BlocListener<DeleteNotesCubit, DeleteState>(
                  // Cubit listener for delete operations
                  listener: (context, state) {
                    if (state is DeleteLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    }
                    if (state is DeleteSuccess) {
                      setState(() {
                        isLoading = false;
                        selectedNotes.clear();
                        isSelecting =
                            false; // Exit selection mode after deletion
                      });
                      context.read<NotesCubit>().fetchNotes(userId);
                      AwesomeDialog(
                        buttonsTextStyle: FontsManager.font17WhiteMedium,
                        descTextStyle: FontsManager.font15BlackRegular,
                        titleTextStyle: FontsManager.font26BlackBold,
                        context: context,
                        animType: AnimType.bottomSlide,
                        dialogType: DialogType.success,
                        showCloseIcon: true,
                        title: 'Success',
                        desc: 'Notes deleted successfully!',
                        btnOkOnPress: () {},
                        btnOkColor: ColorManager.mainblue,
                      ).show();
                    } else if (state is DeleteFailure) {
                      setState(() {
                        isLoading = false;
                      });
                      AwesomeDialog(
                        buttonsTextStyle: FontsManager.font17WhiteMedium,
                        descTextStyle: FontsManager.font15BlackRegular,
                        titleTextStyle: FontsManager.font26BlackBold,
                        context: context,
                        animType: AnimType.bottomSlide,
                        dialogType: DialogType.error,
                        showCloseIcon: true,
                        title: 'Failed',
                        desc: state.errorMessage,
                        btnOkOnPress: () {},
                        btnOkColor: ColorManager.mainblue,
                      ).show();
                    }
                  },
                  child: BlocBuilder<NotesCubit, NotesState>(
                    // Cubit builder for notes state
                    builder: (context, state) {
                      if (state is NotesLoading) {
                        return Skeletonizer(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 10.h,
                              crossAxisSpacing: 10.w,
                              childAspectRatio: 346.w / 170.h,
                            ),
                            itemCount: 5, // Number of skeleton items
                            itemBuilder: (context, index) {
                              return NoteCardSkeleton();
                            },
                          ),
                        );
                      } else if (state is NotesFailure) {
                        return Center(child: Text(state.errorMessage));
                      } else if (state is NotesLoaded) {
                        allNotes =
                            state.notes; // Store all notes for filtering
      
                        // Sort notes by createdAt in descending order
                        allNotes.sort((a, b) => b.createdAt.compareTo(a
                            .createdAt)); // Adjust this line based on your timestamp property
      
                        List<NoteModel> filteredNotes =
                            allNotes.where((note) {
                          return note.title
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()) ||
                              note.note
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase());
                        }).toList(); // Filter notes based on search query
      
                        if (filteredNotes.isEmpty) {
                          return Center(
                            child: Text(
                              'No notes available.',
                              style: FontsManager.font18GreyRegular,
                            ),
                          );
                        }
                        return RefreshIndicator(
                          color: ColorManager.mainblue,
                          onRefresh: _refreshNotes, // Call to refresh notes
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 10.h,
                              crossAxisSpacing: 10.w,
                              childAspectRatio: 346.w / 170.h,
                            ),
                            itemCount: filteredNotes.length,
                            itemBuilder: (context, index) {
                              final note = filteredNotes[index];
                              final isSelected = selectedNotes.contains(note);
                              return GestureDetector(
                                onLongPress: () {
                                  if (!isSelecting) {
                                    startSelecting();
                                  }
                                  toggleSelect(note);
                                },
                                onTap: () async {
                                  if (isSelecting) {
                                    toggleSelect(note);
                                  } else {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditNoteScreen(note: note),
                                      ),
                                    );
                                    // Refresh notes after returning from EditNoteScreen
                                    context
                                        .read<NotesCubit>()
                                        .fetchNotes(userId);
                                  }
                                },
                                child: Stack(
                                  children: [
                                    NoteCard(
                                      note: note,
                                      onToggleFavorite: toggleFavoriteStatus,
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: 20,
                                        right: 16,
                                        child: Icon(
                                          Ionicons.checkbox,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Container(); // Return an empty container for unknown states
                    },
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

// Custom skeleton card for loading templates
