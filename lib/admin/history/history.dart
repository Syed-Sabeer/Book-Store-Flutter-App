import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Purchase History"),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHistoryCard('User: John Doe', 'Order #12345', 'Completed'),
          _buildHistoryCard('User: Jane Smith', 'Order #12346', 'Completed'),
          _buildHistoryCard('User: Mike Ross', 'Order #12347', 'Returned'),
          // Add more history as necessary
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String userName, String orderId, String status) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(userName),
        subtitle: Text('Order ID: $orderId\nStatus: $status'),
        trailing: ElevatedButton(
          onPressed: () {
            // Logic to view more details of the history
          },
          child: const Text('View Details'),
        ),
      ),
    );
  }
}
