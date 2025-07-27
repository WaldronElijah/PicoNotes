import 'package:flutter/material.dart';
import 'responsive_utils.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => ResponsiveUtils.screenWidth(this);
  double get screenHeight => ResponsiveUtils.screenHeight(this);
  
  bool get isSmallScreen => ResponsiveUtils.isSmallScreen(this);
  bool get isMediumScreen => ResponsiveUtils.isMediumScreen(this);
  bool get isLargeScreen => ResponsiveUtils.isLargeScreen(this);
  
  double get horizontalPadding => ResponsiveUtils.horizontalPadding(this);
  double get cardWidth => ResponsiveUtils.cardWidth(this);
  double get cardHeight => ResponsiveUtils.cardHeight(this);
  double get carouselHeight => ResponsiveUtils.carouselHeight(this);
  double get singleRowHeight => ResponsiveUtils.singleRowHeight(this);
  double get horizontalItemWidth => ResponsiveUtils.horizontalItemWidth(this);
  
  double get headingFontSize => ResponsiveUtils.headingFontSize(this);
  double get titleFontSize => ResponsiveUtils.titleFontSize(this);
  double get cardTitleFontSize => ResponsiveUtils.cardTitleFontSize(this);
  double get cardDateFontSize => ResponsiveUtils.cardDateFontSize(this);
  
  double get verticalSpacing => ResponsiveUtils.verticalSpacing(this);
  double get sectionSpacing => ResponsiveUtils.sectionSpacing(this);
}

extension ResponsiveWidget on Widget {
  Widget responsivePadding(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context),
      ),
      child: this,
    );
  }
} 