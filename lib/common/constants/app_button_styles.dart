
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppButtonStyles {
  static ButtonStyle largeButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return TextButton.styleFrom(
      foregroundColor: AppColors.textsecondaryColor,
     // backgroundColor: Color.fromARGB(255, 10, 58, 29), // Button color
     backgroundColor: Colors.black,
      minimumSize: Size(screenWidth * 0.5, 50), // Button size
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      shadowColor: Colors.black.withOpacity(0.2),
      elevation: 5,
    ).copyWith(
      overlayColor: MaterialStateProperty.all(Colors.black.withOpacity(0.1)),
    );
  }

  static ButtonStyle smallButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return TextButton.styleFrom(
      foregroundColor: AppColors.textsecondaryColor,
     // backgroundColor: Color.fromARGB(255, 10, 58, 29), // Button color
     backgroundColor: Colors.black,
      minimumSize: Size(screenWidth * 0.4, 50), // Button size
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      shadowColor: Colors.black.withOpacity(0.2),
      elevation: 5,
    ).copyWith(
      overlayColor: MaterialStateProperty.all(Colors.black.withOpacity(0.1)),
    );
  }

  static ButtonStyle smallButtonWhite(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return TextButton.styleFrom(
      foregroundColor: AppColors.textPrimaryColor,
      backgroundColor: AppColors.textsecondaryColor,
      minimumSize: Size(screenWidth * 0.4, 50),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.black.withOpacity(0.2)), // Adding a border
      ),
      shadowColor: Colors.black.withOpacity(0.5), // Increasing shadow opacity
      elevation: 5,
    ).copyWith(
      overlayColor: MaterialStateProperty.all(Colors.black.withOpacity(0.1)),
    );
  }

 
}
