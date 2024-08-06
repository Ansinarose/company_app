import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SentPaymentsWidget extends StatelessWidget {
  final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
   return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('payments')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No payments sent yet.'));
        }

        double totalAmount = 0;
        List<Widget> paymentWidgets = [];

        for (var doc in snapshot.data!.docs) {
          var payment = doc.data() as Map<String, dynamic>;
          double amount = double.tryParse(payment['amount'].toString()) ?? 0;
          totalAmount += amount;

          paymentWidgets.add(
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('workers_request')
                  .doc(payment['workerId'])
                  .get(),
              builder: (context, workerSnapshot) {
                String workerName = 'Unknown Worker';
                if (workerSnapshot.hasData && workerSnapshot.data!.exists) {
                  workerName = workerSnapshot.data!.get('name') ?? 'Unknown Worker';
                }
                String dateFormatted = _formatDate(payment['timestamp']);
                List<String> dateParts = dateFormatted.split(' ');
                String date = dateParts[0];
                String time = dateParts[1];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('Amount: ${currencyFormat.format(amount)}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Worker: $workerName'),
                        Text('ID: ${payment['paymentId']}'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(date),
                        Text(time),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                children: paymentWidgets,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Text(
                'Total Amount Sent: ${currencyFormat.format(totalAmount)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
}
