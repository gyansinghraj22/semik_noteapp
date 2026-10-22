import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteCardItem extends StatelessWidget {
  const NoteCardItem({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> deleteNote(BuildContext context) async {
      final bool? isDeleted = await showCupertinoDialog<bool>(
        context: context,
        builder: (BuildContext showDialog) {
          return CupertinoAlertDialog(
            title: Text("Delete Note"),
            content: Text("Are you sure you want to delete this note"),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(showDialog, true);
                },
                child: const Text("Accept"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(showDialog, false);
                },
                child: Text("Cancel"),
              ),
            ],
          );
        },
      );
      if (isDeleted == true) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Note Deleted Succesfully")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Delete Canceled")));
      }
    }

    return Container(
      width: 340, // Adjust width as needed or remove for full width
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F6), // Soft light-gray/cream background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFECE6), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row: Category chip, Date, and Top-Right Icons
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE5E0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Personal",
                  style: TextStyle(
                    color: Color(0xFF5F5A55),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Oct 14",
                style: TextStyle(
                  color: Color(0xFF8C857E),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(Icons.star_border, size: 20, color: Color(0xFF7A726A)),
              const SizedBox(width: 12),
              const Icon(Icons.more_vert, size: 20, color: Color(0xFF7A726A)),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          const Text(
            "Coffee Roasting & Extracti...",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF1D1B18),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          // Content body preview
          const Text(
            "Ethiopian Yirgacheffe washed lot 42. Adjusted grind size finer to 14 clicks on Timemore. Total brew time...",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF6B645D),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Bottom Row: Tags/Checklist badge and lock icon
          Row(
            children: [
              // Checklist Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE5E0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_box_outlined,
                      size: 14,
                      color: Color(0xFF5F5A55),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "4/5 done",
                      style: TextStyle(
                        color: Color(0xFF5F5A55),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Hashtag Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE5E0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "#pourover",
                  style: TextStyle(
                    color: Color(0xFF5F5A55),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),

              Row(
                children: [
                  IconButton(
                    onPressed: () => deleteNote(context),
                    icon: Icon(Icons.delete, color: Colors.red, size: 16),
                  ),
                  SizedBox(height: 12),
                  const Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: Color(0xFF8C857E),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}