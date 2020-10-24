import 'package:flutter/material.dart';
import 'package:nyue/util/font_manager.dart';

class ColorManager {
  ColorManager();
  final cardTitleColor = Color(0xff333333);
  final cardSubTitleColor = Color(0xff999999);

  final green = Colors.green;
  final white = Colors.white;
  final blue = Colors.blue;
  final grayLevel1 = Color(0xff333333);
  final grayLevel2 = Color(0xff666666);
  final grayLevel3 = Color(0xff999999);
  final grayLevel4 = Color(0xffcccccc);
  final grayLevel5 = Color(0xffe6e6e6);
  final grayLevel6 = Color(0xff6f5f5f5);
}

class ThemeManager {
  ThemeManager();
  final font = FontManager();
  final color = ColorManager();
  TextStyle get cardTitleStyle => TextStyle(
      fontSize: font.cardTitleFontSize,
      color: color.grayLevel1,
      fontWeight: FontWeight.bold);
  TextStyle get cardSubTitleStyle =>
      TextStyle(fontSize: font.cardSubTitleFontSize, color: color.grayLevel3);

  TextStyle get titleStyle => TextStyle(
      fontSize: 18, //font.titleFontSize,
      color: color.grayLevel1,
      fontWeight: FontWeight.bold);
  TextStyle get subTitleStyle =>
      TextStyle(fontSize: font.titleFontSize, color: color.grayLevel3);
  TextStyle get descStyle =>
      TextStyle(fontSize: 14 /* font.titleFontSize */, color: color.grayLevel2);
}

final ZTheme = ThemeManager();
