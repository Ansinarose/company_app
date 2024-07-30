// import 'package:company_application/common/constants/app_button_styles.dart';
// import 'package:company_application/common/constants/app_colors.dart';
// import 'package:company_application/common/constants/app_text_styles.dart';
// import 'package:company_application/features/workers/available_worker.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart'; // For date formatting

// class OrderDetailsScreen extends StatelessWidget {
//   final DocumentSnapshot order;

//   const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Format the timestamp
//     String formattedDate = 'N/A';
//     if (order['timestamp'] != null) {
//       formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(order['timestamp'].toDate());
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Details'),
//         backgroundColor: AppColors.textPrimaryColor,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image
//               Container(
//                 width: double.infinity,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   image: DecorationImage(
//                     image: NetworkImage(order['productImage']),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Text('Product: ${order['productTitle']}', style: AppTextStyles.subheading(context)),
//               SizedBox(height: 8),
//               Text('Price: ₹${order['productPrice']}', style: AppTextStyles.body(context)),
//               SizedBox(height: 8),
//               Text('Color: ${order['selectedColor']}', style: AppTextStyles.body(context)),
//               SizedBox(height: 8),
//               Text('Booking Date: $formattedDate', style: AppTextStyles.body(context)),
//               SizedBox(height: 16),
//               Text('Delivery Address:', style: AppTextStyles.subheading(context)),
//               Text('${order['address']['name']}', style: AppTextStyles.body(context)),
//               Text('${order['address']['houseNo']}, ${order['address']['road']}', style: AppTextStyles.body(context)),
//               Text('${order['address']['city']}, ${order['address']['state']} - ${order['address']['pincode']}', style: AppTextStyles.body(context),),
//               Text('Phone: ${order['address']['phone']}', style: AppTextStyles.body(context)),
//               SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     style: AppButtonStyles.smallButton(context),
//                     onPressed: () {
//                       // Handle accept logic here
//                       _handleAccept(context);
//                     },
//                     child: Text('Accept'),
//                   ),
//                   ElevatedButton(
                
//                     style: AppButtonStyles.smallButton(context),
//                     onPressed: () {
//                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AvailableWorkerScreen(
//                         orderDetails: {
//                            'orderId': order.id,
//                            'userId': order['userId'],
//                           'productTitle': order['productTitle'],
//                           'productPrice': order['productPrice'],
//                           'selectedColor': order['selectedColor'],
//                           'address': order['address'],
//                           'productImage': order['productImage'],
//                         },)));
                      
//                     },
//                     child: Text('Forward'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleAccept(BuildContext context) {
//   FirebaseFirestore.instance.collection('Customerbookings').doc(order.id).update({
//     'status': 'accepted',
//     'acceptedAt': FieldValue.serverTimestamp(),
//     'bookingConfirmedAt': FieldValue.serverTimestamp(), 
//   }).then((_) {
//     // Send notification to customer
//     _sendCustomerNotification(order['userId']);
    
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order accepted and customer notified')));
//     Navigator.pop(context); // Go back to the previous screen
//   }).catchError((error) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to accept order: $error')));
//   });
// }

// void _sendCustomerNotification(String customerId) {
//   FirebaseFirestore.instance.collection('customer_notifications').add({
//     'userId': customerId,
//     'message': 'Your order has been accepted. We will process it soon.',
//     'orderId': order.id,
//     'timestamp': FieldValue.serverTimestamp(),
//     'read': false,
//   });
// }
// }
import 'package:company_application/common/constants/app_button_styles.dart';
import 'package:company_application/common/constants/app_colors.dart';
import 'package:company_application/common/constants/app_text_styles.dart';
import 'package:company_application/features/workers/available_worker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class OrderDetailsScreen extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the timestamp
    String formattedDate = 'N/A';
    if (order['timestamp'] != null) {
      formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(order['timestamp'].toDate());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: AppColors.textPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(order['productImage']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Product: ${order['productTitle']}', style: AppTextStyles.subheading(context)),
                  SizedBox(height: 8),
                  Text('Price: ₹${order['productPrice']}', style: AppTextStyles.body(context)),
                  SizedBox(height: 8),
                  Text('Color: ${order['selectedColor']}', style: AppTextStyles.body(context)),
                  SizedBox(height: 8),
                  Text('Booking Date: $formattedDate', style: AppTextStyles.body(context)),
                  SizedBox(height: 16),
                  Text('Delivery Address:', style: AppTextStyles.subheading(context)),
                  Text('${order['address']['name']}', style: AppTextStyles.body(context)),
                  Text('${order['address']['houseNo']}, ${order['address']['road']}', style: AppTextStyles.body(context)),
                  Text('${order['address']['city']}, ${order['address']['state']} - ${order['address']['pincode']}', style: AppTextStyles.body(context)),
                  Text('Phone: ${order['address']['phone']}', style: AppTextStyles.body(context)),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: AppButtonStyles.smallButton(context),
                        onPressed: () {
                          // Handle accept logic here
                          _handleAccept(context);
                        },
                        child: Text('Accept'),
                      ),
                      ElevatedButton(
                        style: AppButtonStyles.smallButton(context),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AvailableWorkerScreen(
                              orderDetails: {
                                'orderId': order.id,
                                'userId': order['userId'],
                                'productTitle': order['productTitle'],
                                'productPrice': order['productPrice'],
                                'selectedColor': order['selectedColor'],
                                'address': order['address'],
                                'productImage': order['productImage'],
                              },
                            ),
                          ));
                        },
                        child: Text('Forward'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleAccept(BuildContext context) {
    FirebaseFirestore.instance.collection('Customerbookings').doc(order.id).update({
      'status': 'accepted',
      'acceptedAt': FieldValue.serverTimestamp(),
      'bookingConfirmedAt': FieldValue.serverTimestamp(),
    }).then((_) {
      // Send notification to customer
      _sendCustomerNotification(order['userId']);
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order accepted and customer notified')));
      Navigator.pop(context); // Go back to the previous screen
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to accept order: $error')));
    });
  }

  void _sendCustomerNotification(String customerId) {
    FirebaseFirestore.instance.collection('customer_notifications').add({
      'userId': customerId,
      'message': 'Your order has been accepted. We will process it soon.',
      'orderId': order.id,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });
  }
}
