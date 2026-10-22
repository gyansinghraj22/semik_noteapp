import 'package:flutter/material.dart';

import 'package:noteapp/features/note/model/note_model.dart';
import 'package:noteapp/features/note/widgets/note_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final Set<String> selectedFilters = {};
  final List<NoteModel> sampleNotes = [
    NoteModel(
      id: 1,
      title: 'Morning Routine',
      content: 'Wake up at 6:00 AM, drink a glass of water, do 20 minutes of exercise, and spend 15 minutes reading.',
      createdAt: DateTime(2026, 10, 10, 6, 30),
      updatedAt: DateTime(2026, 10, 10, 7, 15),
      isPinned: true,
      isFavourite: true,
      categoryId: 1,
    ),
    NoteModel(
      id: 2,
      title: 'Flutter Project Ideas',
      content: 'Build a notes app with categories, search, dark mode, local database storage, and the ability to pin and favourite notes.',
      createdAt: DateTime(2026, 10, 11, 10, 0),
      updatedAt: DateTime(2026, 10, 12, 14, 30),
      isPinned: true,
      isFavourite: true,
      categoryId: 2,
    ),
    NoteModel(
      id: 3,
      title: 'Grocery Shopping List',
      content: 'Buy rice, milk, eggs, bread, fresh vegetables, apples, cooking oil, and coffee from the supermarket.',
      createdAt: DateTime(2026, 10, 12, 9, 0),
      updatedAt: DateTime(2026, 10, 12, 9, 0),
      isPinned: false,
      isFavourite: false,
      categoryId: 3,
    ),
    NoteModel(
      id: 4,
      title: 'Meeting Notes',
      content: 'Discuss the project timeline, review the current design, assign tasks to team members, and finalize the next release date.',
      createdAt: DateTime(2026, 10, 13, 11, 0),
      updatedAt: DateTime(2026, 10, 13, 12, 15),
      isPinned: true,
      isFavourite: false,
      categoryId: 4,
    ),
    NoteModel(
      id: 5,
      title: 'Learning Dart',
      content: 'Review classes, constructors, inheritance, null safety, lists, maps, asynchronous programming, and Future and Stream.',
      createdAt: DateTime(2026, 10, 13, 16, 0),
      updatedAt: DateTime(2026, 10, 14, 8, 30),
      isPinned: false,
      isFavourite: true,
      categoryId: 2,
    ),
    NoteModel(
      id: 6,
      title: 'Monthly Budget',
      content: 'Track monthly expenses for rent, groceries, transportation, internet, electricity, savings, and personal spending.',
      createdAt: DateTime(2026, 10, 14, 9, 30),
      updatedAt: DateTime(2026, 10, 15, 10, 0),
      isPinned: false,
      isFavourite: false,
      categoryId: 5,
    ),
    NoteModel(
      id: 7,
      title: 'Book Recommendations',
      content: 'Read Atomic Habits by James Clear, Deep Work by Cal Newport, and The Psychology of Money by Morgan Housel.',
      createdAt: DateTime(2026, 10, 15, 13, 0),
      updatedAt: DateTime(2026, 10, 15, 13, 45),
      isPinned: false,
      isFavourite: true,
      categoryId: 6,
    ),
    NoteModel(
      id: 8,
      title: 'Weekend Travel Plan',
      content: 'Plan a weekend trip with friends. Check transportation options, accommodation, weather, travel costs, and places to visit.',
      createdAt: DateTime(2026, 10, 16, 8, 0),
      updatedAt: DateTime(2026, 10, 16, 8, 30),
      isPinned: true,
      isFavourite: false,
      categoryId: 7,
    ),
    NoteModel(
      id: 9,
      title: 'Important Reminders',
      content: 'Renew the subscription, back up important project files, reply to pending emails, and organize documents.',
      createdAt: DateTime(2026, 10, 17, 14, 0),
      updatedAt: DateTime(2026, 10, 18, 9, 15),
      isPinned: false,
      isFavourite: false,
      categoryId: 1,
    ),
    NoteModel(
      id: 10,
      title: 'Personal Goals',
      content: 'Improve programming skills, finish the current Flutter project, read regularly, save money each month, and maintain a balanced routine.',
      createdAt: DateTime(2026, 10, 18, 19, 0),
      updatedAt: DateTime(2026, 10, 19, 8, 0),
      isPinned: true,
      isFavourite: true,
      categoryId: 1,
    ),
  ];

  final List<String> filterChips = const [
    "All(4)",
    "Work(2)",
    "Personal(1)",
    "Ideas(1)",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          "Favourites",
                          maxLines: 1,
                          style: TextStyle(
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Add menu or filter action here.
                        },
                        icon: const Icon(
                          Icons.align_horizontal_left_sharp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  // Subtitle
                  const Text(
                    "4 starred notes. Starred for quick access",
                    maxLines: 1,
                    style: TextStyle(color: Colors.black, fontSize: 10),
                  ),

                  const SizedBox(height: 16),

                  // Search bar
                  SearchBar(
                    hintText: "Search favourites...",
                    leading: const Icon(Icons.search),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Horizontal filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filterChips.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            avatar: const Icon(Icons.person, size: 16),
                            label: Text(filter),
                            selected: selectedFilters.contains(filter),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedFilters.add(filter);
                                } else {
                                  selectedFilters.remove(filter);
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: NoteCardItem(),
                );
              }, childCount: sampleNotes.length),
            ),
          ],
        ),
      ),
    );
  }
}