import 'package:flutter/material.dart';

class PinnedNoteCard extends StatelessWidget {
  const PinnedNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260, // Giving a fixed width for horizontal scrolling cards looks much better!
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Shrink-wrap the column contents vertically
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      "Work",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 231, 201, 236),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  const Icon(
                    Icons.star,
                    color: Color.fromARGB(255, 145, 39, 0),
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Q3 Mobile Architecture",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Targeting atomic local QOLite persistence and if you want to learn more about us contact us",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(
                    Icons.alarm,
                    size: 16,
                    color: Color.fromARGB(255, 81, 81, 81),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Oct 20, 2026",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}