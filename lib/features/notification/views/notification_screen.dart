
import 'package:flutter/material.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/features/notification/views/order_request.dart';
import 'package:company_application/features/notification/views/worker_request_notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: ListView(
        children: [
          _buildNotificationSection(
            context,
            'New Orders',
            NewOrdersList(),
            Icons.shopping_cart,
          ),
          _buildNotificationSection(
            context,
            'Worker Requests',
            WorkerRequestList(),
            Icons.person_add,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(
    BuildContext context,
    String title,
    Widget destinationScreen,
    IconData icon,
  ) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textPrimaryColor),
        title: Text(title, style: AppTextStyles.subheading(context)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          );
        },
      ),
    );
  }
}