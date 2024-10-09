import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:my_notes_app/core/widgets/note_card.dart';
import 'package:my_notes_app/features/edit_note/ui/edit_note.dart';
import 'package:my_notes_app/features/home/data/models/note_model.dart';
import 'package:my_notes_app/features/home/logic/notes%20cubit/notes_cubit_cubit.dart';

class FavoritesNotesScreen extends StatefulWidget {
  const FavoritesNotesScreen({super.key});

  @override
  State<FavoritesNotesScreen> createState() => _FavoritesNotesState();
}

class _FavoritesNotesState extends State<FavoritesNotesScreen> {
  String searchQuery = "";
  List<NoteModel> filteredNotes = [];
  bool isLoading = false;
  bool isSelecting = false; // Selection state
  final userId = FirebaseAuth.instance.currentUser!.uid;
  List<NoteModel> selectedNotes = [];

  void toggleSelect(NoteModel note) {
    setState(() {
      if (selectedNotes.contains(note)) {
        selectedNotes.remove(note); // Deselect
      } else {
        selectedNotes.add(note); // Select
      }
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

  void clearSearch() {
    setState(() {
      searchQuery = "";
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<NotesCubit>().fetchNotes(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundcolor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Text(
                  'Favorites',
                  style: FontsManager.font26BlackBold,
                ),
              ),
              CupertinoSearchTextField(
                prefixInsets: const EdgeInsets.symmetric(horizontal: 15),
                placeholderStyle: FontsManager.font18GreyRegular,
                style: FontsManager.font15BlackRegular,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              SizedBox(height: 20.h),
              Text(
                'Search Results',
                style: FontsManager.font15DarkBlackBold,
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: BlocBuilder<NotesCubit, NotesState>(
                  builder: (context, state) {
                    if (state is NotesLoading) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Loading your favorite notes...'),
                          ],
                        ),
                      );
                    } else if (state is NotesLoaded) {
                      // Filter notes based on the search query and favorite status
                      filteredNotes = state.notes.where((note) {
                        return (note.isFavorite && // Only show favorite notes
                            (note.title
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase()) ||
                                note.note
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase())));
                      }).toList();

                      if (filteredNotes.isEmpty) {
                        return Center(
                          child: Text(
                            'No notes found.',
                            style: FontsManager.font18GreyRegular,
                          ),
                        );
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                context.read<NotesCubit>().fetchNotes(userId);
                              }
                            },
                            child: Stack(
                              children: [
                                NoteCard(
                                  note: note,
                                  onToggleFavorite: (NoteModel note) {
                                    // Toggle favorite status
                                    setState(() {
                                      note.isFavorite = !note.isFavorite;
                                    });
                                    // Update the note in Firestore
                                    FirebaseFirestore.instance
                                        .collection('notes')
                                        .doc(note.id)
                                        .update({
                                      'isFavorite': note.isFavorite,
                                    });
                                  },
                                ),
                                if (isSelected)
                                  const Positioned(
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
                      );
                    } else if (state is NotesFailure) {
                      return Center(child: Text(state.errorMessage));
                    }
                    return Container(); // Return an empty container for unknown states
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
