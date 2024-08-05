import 'package:company_application/common/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:company_application/common/widgets/worker_chatlist_widget.dart';
import 'package:company_application/common/widgets/customer_chatlist_widget.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundcolor,
        appBar: AppBar(
          backgroundColor: AppColors.textPrimaryColor,
          title: Text('Chats'),
          bottom: TabBar(
            indicatorColor: AppColors.textsecondaryColor, 
            labelColor: AppColors.textsecondaryColor,
            unselectedLabelColor: const Color.fromARGB(255, 76, 76, 76),
            tabs: [
              Tab(text: 'Workers'),
              Tab(text: 'Customers'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WorkerChatList(),
            CustomerChatList(),
          ],
        ),
      ),
    );
  }
}
