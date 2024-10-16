import 'package:employeetracker/utils/sizer_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'colors.dart';

class AppStyles {
  static BoxDecoration inputBoxStyle = BoxDecoration(
      borderRadius: BorderRadius.circular(8.0), color: AppColors.textColor);

  static BoxDecoration inputBoxStyleEmail = BoxDecoration(
    border: Border.all(color: AppColors.accentColor, width: 1.0),
    borderRadius: BorderRadius.circular(4.0),
    color: AppColors.textColor,
  );

  static InputDecoration getInputDecorationStyle(
      {String? hint, IconData? icon}) {
    return InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        errorStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(
            color: AppColors.hintColor,
            fontSize: SizerHelper.adaptiveSpToPx(16),
            fontWeight: FontWeight.w400,
            textBaseline: TextBaseline.alphabetic,
            fontStyle: FontStyle.normal),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none);
  }

  static InputDecoration getInputDecorationStyleEmail(
      {String? hint, IconData? icon}) {
    return InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        errorStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(
          color: AppColors.accentColor,
          fontSize: SizerHelper.adaptiveSpToPx(16),
          textBaseline: TextBaseline.alphabetic,
        ),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none);
  }

  static const inputTextStyle = TextStyle(
      fontSize: 20,
      color: AppColors.textColor,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500);

  static const background = BoxDecoration(color: AppColors.backgroundColor);

  static const inputBoxPadding =
      EdgeInsets.only(left: 24.0, bottom: 8.0, top: 16.0, right: 24.0);
}
