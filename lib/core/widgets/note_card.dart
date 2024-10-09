import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:my_notes_app/core/utils/fonts.dart';
import 'package:my_notes_app/core/utils/colors.dart';
import 'package:my_notes_app/features/home/data/models/note_model.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onToggleFavorite, // Pass in the toggle function
  });

  final NoteModel note;
  final Function(NoteModel) onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: ColorManager.mainblue,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            title: Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                note.title,
                style: FontsManager.font20WhiteMedium),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  note.note,
                  style: FontsManager.font17WhiteLight),
            ),
            trailing: IconButton(
              onPressed: () {
                onToggleFavorite(note); // Call the toggle function
              },
              icon: Icon(
                note.isFavorite ? Ionicons.heart : Ionicons.heart_outline,
                color: note.isFavorite ? Colors.white : Colors.white,
                size: 32,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
                DateFormat(' dd MMM yyyy, hh:mm a')
                    .format(note.createdAt.toDate()),
                style: FontsManager.font13WhiteExLight),
          )
        ],
      ),
    );
  }
}
