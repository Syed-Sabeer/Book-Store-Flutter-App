import 'package:flutter/material.dart';
import 'package:book_grocer/admin/action/cancelledorder_view.dart'; // Adjust the import path as needed

class CancelledOrdersPage extends StatelessWidget {
  const CancelledOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    final List<Map<String, dynamic>> cancelledOrders = [
      {
        "id": "CN001",
        "user": "Nancy Wilson",
        "totalPrice": 22.99,
        "date": "2024-09-21",
      },
      {
        "id": "CN002",
        "user": "David Taylor",
        "totalPrice": 18.75,
        "date": "2024-09-22",
      },
      {
        "id": "CN003",
        "user": "Laura Lee",
        "totalPrice": 32.50,
        "date": "2024-09-23",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancelled Orders', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: cancelledOrders.length,
        itemBuilder: (context, index) {
          final order = cancelledOrders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(Icons.cancel, color: Colors.red, size: 36),
              title: Text('Order ID: ${order['id']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User: ${order['user']}', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text('Date: ${order['date']}', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              trailing: Text(
                '\$${order['totalPrice'].toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              onTap: () {
                // Navigate to Cancelled View Page (you need to implement CancelledViewPage)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderCancelledViewPage(order: order),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
