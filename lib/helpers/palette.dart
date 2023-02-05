import 'package:flutter/material.dart';

class AppColors {
AppColors._();
  static Color bgColor = Color(0xff9E77F3);
  static Color bgColor1 = Color(0xffFCC2FC);
  static Color accentColor = Color(0xff2BBCED);
  static Color accentColor2 = Color(0xff1D1D1D);
  static Color accentColor3 = Color(0xff292929);
  static Color txtColor = Color(0xff203D4A);
}

class Textstyle {
  static TextStyle txtStyle = TextStyle(
    color: AppColors.txtColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static TextStyle txtStyle5 = TextStyle(
    color: AppColors.txtColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static TextStyle txtStyle6 = TextStyle(
    color: AppColors.txtColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

}
