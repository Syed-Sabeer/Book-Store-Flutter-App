import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_grocer/admin/action/cancelledorder_view.dart';

class CancelledOrdersPage extends StatelessWidget {
  const CancelledOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Orders',
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: TColor.primary),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('deleted_orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            debugPrint('Firestore Error: ${snapshot.error}');
            return const Center(child: Text('Error fetching cancelled orders'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No cancelled orders found'));
          }

          final List<DocumentSnapshot> orderDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orderDocs.length,
            itemBuilder: (context, index) {
              final orderData = orderDocs[index].data();

              if (orderData == null) {
                debugPrint('Order data is null for document ID: ${orderDocs[index].id}');
                return const SizedBox();
              }

              final order = orderData as Map<String, dynamic>;

              if (!order.containsKey('userId') || !order.containsKey('createdAt') || !order.containsKey('total')) {
                debugPrint('Missing fields in order: ${orderDocs[index].id}');
                return const SizedBox();
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(Icons.cancel, color: Colors.red, size: 36),
                  title: Text('Order ID: ${orderDocs[index].id}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User ID: ${order['userId']}', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      Text('Date: ${(order['createdAt'] as Timestamp).toDate()}',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  trailing: Text(
                    '\$${order['total'].toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderCancelledViewPage(
                          orderId: orderDocs[index].id, // Pass the order ID
                          order: order, // Pass the order data
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
