import 'package:flutter/animation.dart';

class AppMotion {
  AppMotion._();

  static const Duration micro = Duration(milliseconds: 100);
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration long = Duration(milliseconds: 500);
  static const Duration breathe = Duration(milliseconds: 3200);
  static const Duration stagger = Duration(milliseconds: 60);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve breatheCurve = Curves.easeInOutSine;
}
