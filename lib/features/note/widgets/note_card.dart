import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/features/note/model/note_model.dart';

class NoteCardItem extends StatelessWidget {
  final NoteModel note;

  const NoteCardItem({
    super.key,
    required this.note,
  });

  String _formatDate(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}';
  }

  @override
  Widget build(BuildContext context) {
    Future<void> deleteNote(BuildContext context) async {
      final bool? isDeleted = await showCupertinoDialog<bool>(
        context: context,
        builder: (BuildContext showDialog) {
          return CupertinoAlertDialog(
            title: const Text("Delete Note"),
            content: const Text("Are you sure you want to delete this note"),
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
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
      if (context.mounted) {
        if (isDeleted == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Note Deleted Successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Delete Canceled")),
          );
        }
      }
    }

    return Container(
      width: 340,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F6),
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
                child: Text(
                  note.categoryId == 1 ? "Personal" : "Work",
                  style: const TextStyle(
                    color: Color(0xFF5F5A55),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(note.createdAt),
                style: const TextStyle(
                  color: Color(0xFF8C857E),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                note.isFavourite ? Icons.star : Icons.star_border,
                size: 20,
                color: note.isFavourite ? Colors.amber : const Color(0xFF7A726A),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.more_vert, size: 20, color: Color(0xFF7A726A)),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            note.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1D1B18),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          // Content body preview
          Text(
            note.content ?? note.description ?? 'No content',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6B645D),
              fontSize: 13,
              height: 1.4,
            ),
          ),

          // Tomorrow's Task Banner (Full width so it wraps nicely without "...")
          if (note.tomorrowTasks != null && note.tomorrowTasks!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEAE5E0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_box_outlined,
                    size: 16,
                    color: Color(0xFF5F5A55),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Task: ${note.tomorrowTasks!}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF5F5A55),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Bottom Row: Hashtag badge and action icons
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE5E0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "#note_${note.id.substring(note.id.length > 4 ? note.id.length - 4 : 0)}",
                  style: const TextStyle(
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
                    icon: const Icon(Icons.delete, color: Colors.red, size: 16),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    note.isPinned ? Icons.push_pin : Icons.lock_outline,
                    size: 16,
                    color: const Color(0xFF8C857E),
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