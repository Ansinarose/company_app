import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/features/auth/views/login_screen.dart';
import 'package:company_application/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
             
              _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }

 void _handleLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Logout Confirmation",style: AppTextStyles.subheading(context),),
        content: Text("Are you sure you want to logout?",style: AppTextStyles.body(context),),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel",style: AppTextStyles.body(context),),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text("Confirm",style: AppTextStyles.body(context),),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      );
    },
  );
}

}
