
// ignore_for_file: unused_import

import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/features/notification/views/order_request.dart';
import 'package:company_application/features/notification/views/worker_request_notification.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.textPrimaryColor,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'New Orders',),
              Tab(text: 'Worker Request'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            
            NewOrdersList(),
            WorkerRequestList(),
          ],
        ),
      ),
    );
  }
}
