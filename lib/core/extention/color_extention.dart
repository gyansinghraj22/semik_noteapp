import 'package:flutter/material.dart';
import 'package:noteapp/constants/app_colors.dart';

extension MaterialColorExtensions on BuildContext {
  //color
  Color applyAppColors({required MaterialColor palette, int swatch = 500}) =>
      palette[swatch] ?? AppColors.appThemeColor;

  /// Creates a TextStyle with a color from the specified palette and swatch value.
  TextStyle textStyle({required MaterialColor palette, int swatch = 500}) =>
      TextStyle(color: applyAppColors(palette: palette, swatch: swatch));
  TextStyle textBlackStyle() => const TextStyle(color: AppColors.blackColor);
}