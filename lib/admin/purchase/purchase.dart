import 'package:flutter/material.dart';

class PurchasesPage extends StatelessWidget {
  const PurchasesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Orders"),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildOrderCard('Order #12345', 'John Doe', 'Pending'),
          _buildOrderCard('Order #12346', 'Jane Smith', 'Pending'),
          _buildOrderCard('Order #12347', 'Mike Ross', 'Pending'),
          // Add more orders as necessary
        ],
      ),
    );
  }

  Widget _buildOrderCard(String orderId, String customerName, String status) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(orderId),
        subtitle: Text('Customer: $customerName\nStatus: $status'),
        trailing: ElevatedButton(
          onPressed: () {
            // Logic to update the order status or view details
          },
          child: const Text('View Details'),
        ),
      ),
    );
  }
}
