class AppFonts {
  static const plusJarkataSans = 'jarkataSans';
  static const newsReader = 'newsreader';
}

extension AppFontExtensions on String {
  String get withPlusJarkataSans => AppFonts.plusJarkataSans;

  String get withNewsReader => AppFonts.newsReader;
}

class DesignSystemFonts {
  static const headline = AppFonts.newsReader;
  static const bodyText = AppFonts.plusJarkataSans;
  static const labelText = AppFonts.plusJarkataSans;
}




