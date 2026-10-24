import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/constants/api_url.dart';
import 'package:noteapp/core/di/injector.dart';
import 'package:noteapp/core/utils/shared_pref.dart';
import 'package:noteapp/features/auth/bloc/login_bloc.dart';
import 'package:noteapp/features/auth/screen/login_screen.dart';
import 'package:noteapp/features/note/bloc/note_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPref.initializeSharedPreference();
  await setUpDi(ApiUrl.baseUrl);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc()),
        BlocProvider<NoteBloc>(create: (BuildContext context) => NoteBloc()),
      ],
      child: MaterialApp(
        initialRoute: "/",
        routes: {'/': (_) => LoginScreen()},
        debugShowCheckedModeBanner: false,
        title: 'Atelier Notes',

        // 1. LIGHT THEME CONFIGURATION
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          fontFamily:
              'PlusJakartaSans', // Default body & label font from design
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: const Color(0xFF5E5CE6), // #5E5CE6
            onPrimary: Colors.white,
            secondary: const Color(0xFF6E6B82), // #6E6B82
            onSecondary: Colors.white,
            tertiary: const Color(0xFFE06D53), // #E06D53
            onTertiary: Colors.white,
            surface: Colors.white,
            onSurface: const Color(0xFF787672),
            error: const Color(0xFFDC2626),
            onError: Colors.white,
            outline: const Color(0xFF787672), // #787672 Neutral
          ),
          scaffoldBackgroundColor: const Color(
            0xFFF4F1EA,
          ), // Atelier background tone
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.bold,
            ),
            displayMedium: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.bold,
            ),
            displaySmall: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(fontFamily: 'PlusJakartaSans'),
            bodyMedium: TextStyle(fontFamily: 'PlusJakartaSans'),
            bodySmall: TextStyle(fontFamily: 'PlusJakartaSans'),
            labelLarge: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w600,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(
              0xFFEFECE6,
            ), // Matching search box background from UI
            labelStyle: const TextStyle(color: Color(0xFF6E6B82)),
            hintStyle: const TextStyle(color: Color(0xFF787672)),
            prefixIconColor: const Color(0xFF787672),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF5E5CE6)),
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE5E2DA), width: 1),
            ),
          ),
        ),

        // 2. DARK THEME CONFIGURATION
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: 'PlusJakartaSans',
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: const Color(0xFF5E5CE6),
            onPrimary: Colors.white,
            secondary: const Color(0xFF6E6B82),
            onSecondary: Colors.white,
            tertiary: const Color(0xFFE06D53),
            onTertiary: Colors.white,
            surface: const Color(0xFF1E1E22),
            onSurface: Colors.white70,
            error: const Color(0xFFEF4444),
            onError: Colors.white,
            outline: const Color(0xFF787672),
          ),
          scaffoldBackgroundColor: const Color(0xFF141416),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(
              fontFamily: 'Newsreader',
              fontWeight: FontWeight.bold,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF2A2A2E),
            labelStyle: const TextStyle(color: Colors.white70),
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIconColor: Colors.white70,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF5E5CE6)),
            ),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF1E1E22),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        themeMode: ThemeMode.system,
      ),
    );
  }
}
