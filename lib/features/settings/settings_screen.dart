import 'package:company_application/common/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
      //  title: Text('Settings'),
        backgroundColor: AppColors.textPrimaryColor
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment Settings'),
            onTap: () {
              // Handle Payment Settings logic here
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('Customer Feedbacks'),
            onTap: () {
              // Handle Customer Feedbacks logic here
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('App Information'),
            onTap: () {
              // Handle App Information logic here
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Appearance Settings'),
            onTap: () {
              // Handle Appearance Settings logic here
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
            onTap: () {
              // Handle Privacy Policy logic here
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            onTap: () {
              // Handle About logic here
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Handle logout logic here
              _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    // Implement logout logic
    // For example:
    // AuthService.logout();
    Navigator.of(context).popUntil((route) => route.isFirst); // Go back to the login screen
  }
}
