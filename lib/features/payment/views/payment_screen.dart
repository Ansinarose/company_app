import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/features/home/views/home_screen.dart';
import 'package:company_application/services/razorpay_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentsScreen extends StatefulWidget {
  final String workerId;

  PaymentsScreen({required this.workerId});

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final RazorpayService _razorpayService = RazorpayService();
  final TextEditingController _amountController = TextEditingController();
  String? workerName;

  @override
  void initState() {
    super.initState();
    print("PaymentsScreen initialized with workerId: ${widget.workerId}");
    _razorpayService.setPaymentHandler(_handlePaymentSuccess, _handlePaymentError);
    _loadWorkerData();
  }

  Future<void> _loadWorkerData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('attendance').doc(widget.workerId).get();
      if (doc.exists) {
        setState(() {
          workerName = (doc.data() as Map<String, dynamic>)['name'];
        });
      }
    } catch (e) {
      print("Error loading worker data: $e");
    }
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Building PaymentsScreen");
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundcolor,
      appBar: AppBar(
        backgroundColor: AppColors.textPrimaryColor,
        title: Text('Pay Salary', style: AppTextStyles.whiteBody(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (workerName != null)
              Text('Worker Name: $workerName', style: AppTextStyles.body(context)),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Salary Amount (INR)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: AppButtonStyles.largeButton(context),
              child: Text('Pay Now'),
              onPressed: () {
                if (_amountController.text.isNotEmpty) {
                  double amount = double.parse(_amountController.text);
                  _razorpayService.createOrder(amount, widget.workerId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter an amount')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentSuccess(String paymentId, String orderId, String signature) async {
    await FirebaseFirestore.instance.collection('payments').add({
      'workerId': widget.workerId,
      'amount': double.parse(_amountController.text),
      'paymentId': paymentId,
      'orderId': orderId,
      'signature': signature,
      'timestamp': FieldValue.serverTimestamp(),
    });
   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment successful')),
    );
  }

  void _handlePaymentError(String code, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: $message')),
    );
  }
}