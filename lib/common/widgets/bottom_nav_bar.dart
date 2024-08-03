// ignore_for_file: unused_element, unused_import

import 'package:company_application/features/chat/views/chat_list_screen.dart';
import 'package:company_application/features/chat/views/chat_screen.dart';
import 'package:company_application/features/settings/settings_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:company_application/common/constants/app_colors.dart';

class CurvedNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CurvedNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  void _onNavItemTapped(BuildContext context, int index) {
    onTap(index);
    switch (index) {
      case 0:
      Navigator.pushNamed(context, '/home');
        break;
      // In BottomNavigationWidget
 case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatListScreen()),
            );
            break;
  
      case 2:
        // Navigate to Payment
        // Navigator.pushNamed(context, '/payment');
        break;
      case 3:
        // Navigate to Settings
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: AppColors.textPrimaryColor,
      color: AppColors.textPrimaryColor,
      animationDuration: Duration(milliseconds: 500),
      index: selectedIndex,
      onTap: (index) => _onNavItemTapped(context, index),
      items: <Widget>[
        Icon(Icons.home, size: 26, color: Colors.white),
        Icon(Icons.chat, size: 26, color: Colors.white),
        Icon(Icons.payment, size: 26, color: Colors.white),
        Icon(Icons.settings, size: 26, color: Colors.white),
      ],
    );
  }
}
