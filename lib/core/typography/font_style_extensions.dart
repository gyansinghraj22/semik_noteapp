import 'package:flutter/material.dart';
import 'package:noteapp/constants/app_fonts.dart';

extension FontFamilyExtensions on TextStyle {
  TextStyle get withNewsReader => copyWith(fontFamily: AppFonts.newsReader);
  TextStyle get withJarkata => copyWith(fontFamily: AppFonts.plusJarkataSans);
}
