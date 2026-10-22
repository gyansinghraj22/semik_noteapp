import 'package:flutter/material.dart';
import 'package:noteapp/features/note/screen/favorite_screen.dart';
import 'package:noteapp/features/note/screen/note_list_screen.dart';
import 'package:noteapp/features/note/screen/search_screen.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final List<Widget> pages = const [
    NoteListScreen(),
    SearchScreen(),
    FavoriteScreen(),
    Center(child: Text("Settings")),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: ((context) => AddNoteScreen())),
          // );
        },
        backgroundColor: const Color.fromARGB(255, 143, 31, 241),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },

        //main property of the bottomnavigationbar
        // 1. selectedIndex---> identifies the currently selected destination
        // 2. onDestinationSelected---> Runs when the user selects a destination
        // 3. destination--->defined the navigations items
        // 4. icon---> displays the default icon
        // 5. selectedIcons---> displays an alternative icon when selected
        // 6. label--->displays the destinations name
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.notes_outlined),
            selectedIcon: Icon(
              Icons.notes,
              color: Color.fromARGB(255, 133, 42, 172),
            ),
            label: "Notes",
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(
              Icons.search,
              color: Color.fromARGB(255, 133, 42, 172),
            ),
            label: "Search",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outlined),
            selectedIcon: Icon(
              Icons.favorite,
              color: Color.fromARGB(255, 133, 42, 172),
            ),
            label: "Favourites",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(
              Icons.person,
              color: Color.fromARGB(255, 133, 42, 172),
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
