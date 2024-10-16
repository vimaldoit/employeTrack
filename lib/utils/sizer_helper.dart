
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SizerHelper{
  static adaptiveToPxWidth(dynamic num){
      return ((0.25.w) * num);
  }

  static adaptiveToPxHeight(dynamic num){
    return ((0.125.h) * num);
  }

  static adaptiveSpToPx( dynamic num){
    //return (0.72.sp)*num;
    return (0.92.sp)*num;
  }

  static getLineHeight({dynamic fontSize, dynamic lineHeight}){
    return lineHeight / (fontSize-2);
  }
}