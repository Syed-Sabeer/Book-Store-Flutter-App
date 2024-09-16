import 'package:flutter/material.dart';
import 'package:book_grocer/admin/action/shipped_view.dart';

class ShippedOrdersPage extends StatelessWidget {
  const ShippedOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    final List<Map<String, dynamic>> shippedOrders = [
      {
        "id": "S001",
        "user": "Jane Doe",
        "totalPrice": 45.99,
        "date": "2024-09-15",
      },
      {
        "id": "S002",
        "user": "John Smith",
        "totalPrice": 30.50,
        "date": "2024-09-16",
      },
      {
        "id": "S003",
        "user": "Emily Johnson",
        "totalPrice": 60.75,
        "date": "2024-09-17",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipped Orders', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: shippedOrders.length,
        itemBuilder: (context, index) {
          final order = shippedOrders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(Icons.local_shipping, color: Colors.blue, size: 36),
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
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              onTap: () {
                // Navigate to Shipped View Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShippedViewPage(order: order),
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
