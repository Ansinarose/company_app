import 'package:company_application/features/payment/views/recieved_payment_screen.dart';
import 'package:company_application/features/payment/views/sent_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:company_application/common/constants/app_colors.dart';

class PaymentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundcolor,
        appBar: AppBar(
          backgroundColor: AppColors.textPrimaryColor,
          bottom: TabBar(
            indicatorColor: AppColors.textsecondaryColor, 
            labelColor: AppColors.textsecondaryColor, 
            unselectedLabelColor: Color.fromARGB(255, 121, 119, 119), 
            indicatorWeight: 3.0, // Thickness of the indicator line
            tabs: [
              Tab(
                text: 'Received',
                icon: Icon(Icons.inbox), 
              ),
              Tab(
                text: 'Sent',
                icon: Icon(Icons.send), 
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ReceivedPaymentsWidget(),
            SentPaymentsWidget(),
          ],
        ),
      ),
    );
  }
}
