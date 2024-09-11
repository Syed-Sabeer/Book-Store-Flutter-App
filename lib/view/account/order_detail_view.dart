import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order #${order['orderNumber']}"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Details",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Order Number: ${order['orderNumber']}"),
            Text("Date: ${order['date']}"),
            Text("Total: ${order['total']}"),
            Text("Status: ${order['status']}"),
            const SizedBox(height: 20),
            const Text(
              "Books in Order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // List of books (you'll need to add book details to the order data)
            // For example, assuming `order['books']` contains a list of books
            // for (var book in order['books']) ...[
            //   ListTile(
            //     leading: Image.asset(book['image']),
            //     title: Text(book['title']),
            //     subtitle: Text("Price: ${book['price']} - Quantity: ${book['quantity']}"),
            //   )
            // ],
            const SizedBox(height: 20),
            const Text(
              "Delivery Status",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Display delivery status (assuming order data includes delivery status)
            // Text("Tracking Number: ${order['trackingNumber']}"),
            // Text("Expected Delivery: ${order['expectedDelivery']}"),
          ],
        ),
      ),
    );
  }
}
