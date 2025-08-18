import 'dart:math';
import 'package:flutter/material.dart';

class DS {
  // Base Figma frame (iPhone 16) is 393×852 logical px
  static const double baseW = 393.0, baseH = 852.0;

  static double scale(BuildContext c) {
    final mq = MediaQuery.of(c);
    final usableW = mq.size.width;
    final usableH = mq.size.height - mq.viewPadding.top - mq.viewPadding.bottom;
    
    final wScale = usableW / baseW;
    final hScale = usableH / baseH;
    
    // Use the smaller scale to ensure content fits in both dimensions
    return wScale < hScale ? wScale : hScale;
  }

  static double s(BuildContext c, double v) => v * scale(c);
  
  static double sp(BuildContext c, double fs) {
    final scaled = fs * scale(c);
    // Support accessibility but prevent tiny overflows
    return scaled.clamp(fs * 0.9, fs * 1.2);
  }
}
