import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/admin/action/order_view.dart';

class PendingOrdersPage extends StatelessWidget {
  const PendingOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample order data
    final List<Map<String, dynamic>> orders = [
      {
        "id": "1",
        "user": "John Doe",
        "totalAmount": 39.99,
        "date": "2024-09-10",
      },
      {
        "id": "2",
        "user": "Jane Smith",
        "totalAmount": 19.99,
        "date": "2024-09-12",
      },
      // Add more orders if needed
    ];

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
        backgroundColor: Colors.transparent, // Set background color to transparent
        iconTheme: IconThemeData(color: TColor.primary),
        elevation: 0, // Set elevation to 0 if you want no shadow

      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(Icons.local_shipping, color: Colors.orange, size: 36),
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
                '\$${order['totalAmount'].toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderViewPage(order: order),
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
