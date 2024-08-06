
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RazorpayService {
  static const String _keyId = 'rzp_test_8xlE5n49iITFkd';
  static const String _keySecret = 'sqm8in97MFGltKNxYguj3xOU';
  late Razorpay _razorpay;
  late Function(String, String, String) _onPaymentSuccess;
  late Function(String, String) _onPaymentError;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void setPaymentHandler(
    Function(String, String, String) onPaymentSuccess,
    Function(String, String) onPaymentError
  ) {
    _onPaymentSuccess = onPaymentSuccess;
    _onPaymentError = onPaymentError;
  }

  Future<void> createOrder(double amount, String workerId) async {
    final String basicAuth = 'Basic ${base64Encode(utf8.encode('$_keyId:$_keySecret'))}';
    final response = await http.post(
      Uri.parse('https://api.razorpay.com/v1/orders'),
      headers: <String, String>{
        'content-type': 'application/json',
        'Authorization': basicAuth,
      },
      body: jsonEncode({
        'amount': (amount * 100).toInt(),
        'currency': 'INR',
        'receipt': 'receipt_${DateTime.now().millisecondsSinceEpoch}',
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      openCheckout(data['id'], amount, workerId);
    } else {
      throw Exception('Failed to create order');
    }
  }

  void openCheckout(String orderId, double amount, String workerId) async {
  // Fetch worker details
  DocumentSnapshot workerDoc = await FirebaseFirestore.instance.collection('attendance').doc(workerId).get();
  Map<String, dynamic> workerData = workerDoc.data() as Map<String, dynamic>;

  var options = {
    'key': _keyId,
    'amount': (amount * 100).toInt(),
    'name': 'ALFA Aluminium works',
    'order_id': orderId,
    'description': 'Salary payment for ${workerData['name']}',
    'prefill': {'contact': workerData['contact'], 'email': 'test@example.com'},
    'external': {
      'wallets': ['paytm']
    }
  };

  try {
    _razorpay.open(options);
  } catch (e) {
    debugPrint('Error: $e');
  }
}

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _onPaymentSuccess(response.paymentId!, response.orderId!, response.signature!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _onPaymentError(response.code.toString(), response.message ?? "Payment failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet selected: ${response.walletName}");
  }

  void dispose() {
    _razorpay.clear();
  }
}