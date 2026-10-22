import 'package:flutter/material.dart';
import 'package:noteapp/features/note/widgets/note_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchBar(
              hintText: "Search your Notes",
              leading: const Icon(Icons.search),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsetsGeometry.only(bottom: 12),
                    child: NoteCardItem(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
