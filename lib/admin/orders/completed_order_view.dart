import 'package:flutter/material.dart';
import 'package:book_grocer/admin/action/completeorder_view.dart'; // Adjust the import path as needed
import 'package:book_grocer/common/color_extenstion.dart';
class CompletedOrdersPage extends StatelessWidget {
  const CompletedOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    final List<Map<String, dynamic>> completedOrders = [
      {
        "id": "C001",
        "user": "Alice Williams",
        "totalPrice": 55.99,
        "date": "2024-09-18",
      },
      {
        "id": "C002",
        "user": "Bob Brown",
        "totalPrice": 25.75,
        "date": "2024-09-19",
      },
      {
        "id": "C003",
        "user": "Charlie Davis",
        "totalPrice": 40.25,
        "date": "2024-09-20",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Completed Orders',
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
        itemCount: completedOrders.length,
        itemBuilder: (context, index) {
          final order = completedOrders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.check_circle, color: Colors.green, size: 36),
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
                // Navigate to Completed View Page (you need to implement CompletedViewPage)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderCompletedViewPage(order: order),
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
