import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isSmallScreen(BuildContext context) {
    return screenWidth(context) < 375;
  }

  static bool isMediumScreen(BuildContext context) {
    return screenWidth(context) >= 375 && screenWidth(context) < 414;
  }

  static bool isLargeScreen(BuildContext context) {
    return screenWidth(context) >= 414;
  }

  // Dynamic padding based on screen size
  static double horizontalPadding(BuildContext context) {
    final width = screenWidth(context);
    if (width < 375) return 16; // iPhone SE, iPhone 12/13/14 mini
    if (width < 414) return 20; // iPhone 12/13/14/15
    return 24; // iPhone 12/13/14/15 Plus, Pro Max
  }

  // Dynamic card width for 2x2 grid
  static double cardWidth(BuildContext context) {
    final width = screenWidth(context);
    final padding = horizontalPadding(context);
    final availableWidth = width - (padding * 2) - 24; // 24 for spacing between cards
    return (availableWidth - 12) / 2; // 12 for gap between cards
  }

  // Dynamic card height maintaining aspect ratio
  static double cardHeight(BuildContext context) {
    final cardWidth = ResponsiveUtils.cardWidth(context);
    return cardWidth * 1.26; // Slightly increased aspect ratio to accommodate fixed text height
  }

  // Dynamic carousel height for 2x2 grid
  static double carouselHeight(BuildContext context) {
    final cardHeight = ResponsiveUtils.cardHeight(context);
    return (cardHeight * 2) + 12; // Two cards + gap between them
  }

  // Dynamic single row height for 1x1 carousels
  static double singleRowHeight(BuildContext context) {
    return cardHeight(context);
  }

  // Dynamic width for horizontal scrolling items
  static double horizontalItemWidth(BuildContext context) {
    final width = screenWidth(context);
    if (width < 375) return 160; // Smaller screens
    if (width < 414) return 180; // Medium screens
    return 200; // Larger screens
  }

  // Dynamic font sizes
  static double headingFontSize(BuildContext context) {
    final width = screenWidth(context);
    if (width < 375) return 18;
    if (width < 414) return 20;
    return 22;
  }

  static double titleFontSize(BuildContext context) {
    final width = screenWidth(context);
    if (width < 375) return 26;
    if (width < 414) return 28;
    return 30;
  }

  static double cardTitleFontSize(BuildContext context) {
    final width = screenWidth(context);
    if (width < 375) return 12;
    if (width < 414) return 14;
    return 16;
  }

  static double cardDateFontSize(BuildContext context) {
    final width = screenWidth(context);
    if (width < 375) return 10;
    if (width < 414) return 12;
    return 12;
  }

  // Dynamic spacing
  static double verticalSpacing(BuildContext context) {
    final width = screenWidth(context);
    if (width < 375) return 12;
    if (width < 414) return 16;
    return 20;
  }

  static double sectionSpacing(BuildContext context) {
    final width = screenWidth(context);
    if (width < 375) return 20;
    if (width < 414) return 24;
    return 28;
  }
} 