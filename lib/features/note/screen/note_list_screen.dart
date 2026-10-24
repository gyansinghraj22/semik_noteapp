import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/features/note/bloc/note_bloc.dart';
import 'package:noteapp/features/note/bloc/note_event.dart';
import 'package:noteapp/features/note/bloc/note_state.dart';

import 'package:noteapp/features/note/model/note_model.dart';
import 'package:noteapp/features/note/screen/note_details_screen.dart';
import 'package:noteapp/features/note/widgets/note_card.dart';
import 'package:noteapp/features/note/widgets/pinned_note_card.dart';

class FilterChipModel {
  final String name;
  final IconData icon;
  final int notesCounts;
  const FilterChipModel({
    required this.name,
    required this.icon,
    required this.notesCounts,
  });
}

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<NoteBloc>().add(NoteGetEvent(formData: {}));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  final Set<String> selectedFilters = {};
  final List<String> filterChips = ["All", "Personal", "Work"];
  String? query;
  final TextEditingController searchController = TextEditingController();
  final List<NoteModel> sampleNotes = [
    NoteModel(
      id: "1",
      title: 'Morning Routine',
      content: 'Wake up at 6:00 AM, drink a glass of water, do 20 minutes of exercise, and spend 15 minutes reading.',
      createdAt: DateTime(2026, 10, 10, 6, 30),
      updatedAt: DateTime(2026, 10, 10, 7, 15),
      isPinned: true,
      isFavourite: true,
      categoryId: 1,
    ),
    NoteModel(
      id: "2",
      title: 'Flutter Project Ideas',
      content: 'Build a notes app with categories, search, dark mode, local database storage, and the ability to pin and favourite notes.',
      createdAt: DateTime(2026, 10, 11, 10, 0),
      updatedAt: DateTime(2026, 10, 12, 14, 30),
      isPinned: true,
      isFavourite: true,
      categoryId: 2,
    ),
    NoteModel(
      id: "3",
      title: 'Grocery Shopping List',
      content: 'Buy rice, milk, eggs, bread, fresh vegetables, apples, cooking oil, and coffee from the supermarket.',
      createdAt: DateTime(2026, 10, 12, 9, 0),
      updatedAt: DateTime(2026, 10, 12, 9, 0),
      isPinned: false,
      isFavourite: false,
      categoryId: 3,
    ),
    NoteModel(
      id: "4",
      title: 'Meeting Notes',
      content: 'Discuss the project timeline, review the current design, assign tasks to team members, and finalize the next release date.',
      createdAt: DateTime(2026, 10, 13, 11, 0),
      updatedAt: DateTime(2026, 10, 13, 12, 15),
      isPinned: true,
      isFavourite: false,
      categoryId: 4,
    ),
    NoteModel(
      id: "5",
      title: 'Learning Dart',
      content: 'Review classes, constructors, inheritance, null safety, lists, maps, asynchronous programming, and Future and Stream.',
      createdAt: DateTime(2026, 10, 13, 16, 0),
      updatedAt: DateTime(2026, 10, 14, 8, 30),
      isPinned: false,
      isFavourite: true,
      categoryId: 2,
    ),
    NoteModel(
      id: "6",
      title: 'Monthly Budget',
      content: 'Track monthly expenses for rent, groceries, transportation, internet, electricity, savings, and personal spending.',
      createdAt: DateTime(2026, 10, 14, 9, 30),
      updatedAt: DateTime(2026, 10, 15, 10, 0),
      isPinned: false,
      isFavourite: false,
      categoryId: 5,
    ),
    NoteModel(
      id: "7",
      title: 'Book Recommendations',
      content: 'Read Atomic Habits by James Clear, Deep Work by Cal Newport, and The Psychology of Money by Morgan Housel.',
      createdAt: DateTime(2026, 10, 15, 13, 0),
      updatedAt: DateTime(2026, 10, 15, 13, 45),
      isPinned: false,
      isFavourite: true,
      categoryId: 6,
    ),
    NoteModel(
      id: "8",
      title: 'Weekend Travel Plan',
      content: 'Plan a weekend trip with friends. Check transportation options, accommodation, weather, travel costs, and places to visit.',
      createdAt: DateTime(2026, 10, 16, 8, 0),
      updatedAt: DateTime(2026, 10, 16, 8, 30),
      isPinned: true,
      isFavourite: false,
      categoryId: 7,
    ),
    NoteModel(
      id: "9",
      title: 'Important Reminders',
      content: 'Renew the subscription, back up important project files, reply to pending emails, and organize documents.',
      createdAt: DateTime(2026, 10, 17, 14, 0),
      updatedAt: DateTime(2026, 10, 18, 9, 15),
      isPinned: false,
      isFavourite: false,
      categoryId: 1,
    ),
    NoteModel(
      id: "1",
      title: 'Personal Goals',
      content: 'Improve programming skills, finish the current Flutter project, read regularly, save money each month, and maintain a balanced routine.',
      createdAt: DateTime(2026, 10, 18, 19, 0),
      updatedAt: DateTime(2026, 10, 19, 8, 0),
      isPinned: true,
      isFavourite: true,
      categoryId: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            // Top Title Row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Row(
                  children: [
                    const Text(
                      "My Notes",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      child: const Icon(
                        Icons.window_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Notes Counter Row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 6),
                    const Text("12 Notes"),
                    const SizedBox(width: 16),
                    const Text("3 Pinned"),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 16,
                ),
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  controller: searchController,
                  hintText: "Search Products",
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                  trailing: const [
                    Icon(Icons.vertical_distribute_sharp, size: 16),
                  ],
                ),
              ),
            ),

            // Filter Chips
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filterChips.map((filter) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person, size: 16),
                            const SizedBox(width: 4),
                            Text(filter),
                            const SizedBox(width: 4),
                            const Text("123"),
                          ],
                        ),
                        selected: selectedFilters.contains(filter),
                        onSelected: (selected) {
                          setState(() {
                            selected
                                ? selectedFilters.add(filter)
                                : selectedFilters.remove(filter);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Pinned Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: const [
                    Icon(Icons.push_pin, size: 18, color: Colors.brown),
                    SizedBox(width: 10),
                    Text(
                      "Pinned",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Horizontal Pinned Notes List
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: PinnedNoteCard(),
                    );
                  },
                ),
              ),
            ),

            // All Notes Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Text(
                  "All Notes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            BlocBuilder<NoteBloc, NoteState>(
              builder: (context, state) {
                if (state is NoteInitialState) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (state is GetNoteSuccessState) {
                  // 1. Extract the raw list from response data
                  final notesData = (state.response["data"] as List<dynamic>);

                  if (notesData.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("No notes found"),
                        ),
                      ),
                    );
                  }

                  // 2. Map raw JSON maps to NoteModel objects
                  final notes = notesData
                      .map(
                        (json) =>
                            NoteModel.fromMap(json as Map<String, dynamic>),
                      )
                      .toList();

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentNote = notes[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => NoteDetailsScreen(
                                    // Pass the NoteModel if your detail screen accepts it
                                    // note: currentNote,
                                  ),
                                ),
                              );
                            },
                            // Pass the strongly-typed NoteModel to your card item
                            child: NoteCardItem(note: currentNote),
                          ),
                        );
                      }, childCount: 2),
                    ),
                  );
                }

                if (state is GetNoteErrorState) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          "Note loading failed",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            // BlocBuilder<NoteBloc, NoteState>(
            //   builder: (context, state) {
            //     if (state is NoteInitialState) {
            //       return const SliverToBoxAdapter(
            //         child: Center(
            //           child: Padding(
            //             padding: EdgeInsets.all(24.0),
            //             child: CircularProgressIndicator(),
            //           ),
            //         ),
            //       );
            //     }

            //     if (state is GetNoteSuccessState) {
            //       // Safely cast the response data to a List
            //       final notes = (state.response["data"] as List<dynamic>);

            //       if (notes.isEmpty) {
            //         return const SliverToBoxAdapter(
            //           child: Center(
            //             child: Padding(
            //               padding: EdgeInsets.all(20),
            //               child: Text("No notes found"),
            //             ),
            //           ),
            //         );
            //       }

            //       return SliverPadding(
            //         padding: const EdgeInsets.symmetric(horizontal: 16),
            //         sliver: SliverList(
            //           delegate: SliverChildBuilderDelegate((context, index) {
            //             // Changed 'state' to 'index'
            //             // Get the specific note for this row
            //             final currentNote =
            //                 notes[index] as Map<String, dynamic>;

            //             return Padding(
            //               padding: const EdgeInsets.only(bottom: 12),
            //               child: GestureDetector(
            //                 onTap: () {
            //                   Navigator.push(
            //                     context,
            //                     MaterialPageRoute<void>(
            //                       builder: (context) => NoteDetailsScreen(
            //                         // note: currentNote, // Uncomment if your detail screen accepts it
            //                       ),
            //                     ),
            //                   );
            //                 },
            //                 // Pass the current note map to your card item
            //                 child: NoteCardItem(
            //                   // note: currentNote
            //                 ),
            //               ),
            //             );
            //           }, childCount: notes.length),
            //         ),
            //       );
            //     }

            //     if (state is GetNoteErrorState) {
            //       return const SliverToBoxAdapter(
            //         child: Center(
            //           child: Padding(
            //             padding: EdgeInsets.all(24.0),
            //             child: Text(
            //               "Note loading failed",
            //               style: TextStyle(color: Colors.red, fontSize: 16),
            //             ),
            //           ),
            //         ),
            //       );
            //     }

            //     return const SliverToBoxAdapter(child: SizedBox.shrink());
            //   },
            // ),
            // Vertical Notes List
            // SliverList(
            //   delegate: SliverChildBuilderDelegate((context, index) {
            //     return const Padding(
            //       padding: EdgeInsets.only(bottom: 12.0),
            //       child: NoteCardItem(),
            //     );
            //   }, childCount: sampleNotes.length),
            // ),
          ],
        ),
      ),
    );
  }
}
