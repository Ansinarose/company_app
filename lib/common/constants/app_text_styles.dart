
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Heading style with specified font size and weight
  static TextStyle heading(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.textPrimaryColor,
      fontSize: screenWidth * 0.06, // Adjust font size based on screen width
      fontWeight: FontWeight.bold,
    );
  }

  // Body text style with specified font size
  static TextStyle body(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.textPrimaryColor,
      fontSize: screenWidth * 0.04, // Adjust font size based on screen width
    );
  }

  // White body text style with specified font size
  static TextStyle whiteBody(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.textsecondaryColor,
      fontSize: screenWidth * 0.04, // Adjust font size based on screen width
    );
  }

  static TextStyle whitetext(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.textsecondaryColor,
      fontSize: screenWidth * 0.05, // Adjust font size based on screen width
    );
  }

  // Subheading style with medium weight
  static TextStyle subheading(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.textPrimaryColor,
      fontSize: screenWidth * 0.05, // Adjust font size based on screen width
      fontWeight: FontWeight.w600,
    );
  }

  // Caption style
  static TextStyle caption(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.textPrimaryColor,
      fontSize: screenWidth * 0.03, // Adjust font size based on screen width
    );
  }

  // Button text style
  static TextStyle button(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return TextStyle(
      color: AppColors.textsecondaryColor,
      fontSize: screenWidth * 0.04, // Adjust font size based on screen width
      fontWeight: FontWeight.w500,
    );
  }
}
