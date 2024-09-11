import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  final String userName;
  final String userEmail;
  final List<Map<String, String>> purchaseHistory;
  final List<Map<String, String>> pendingOrders;

  const UserDetailsPage({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.purchaseHistory,
    required this.pendingOrders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$userName\'s Profile'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserDetails(),
            const SizedBox(height: 20),
            _buildPurchaseHistory(),
            const SizedBox(height: 20),
            _buildPendingOrders(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User Details', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 10),
          _buildDetailRow('Name:', userName),
          _buildDetailRow('Email:', userEmail),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPurchaseHistory() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Purchase History', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 10),
          ...purchaseHistory.map((purchase) => _buildPurchaseItem(
            purchase['product'] ?? 'Unknown',
            purchase['date'] ?? 'Unknown',
            purchase['amount'] ?? 'Unknown',
          )),
        ],
      ),
    );
  }

  Widget _buildPurchaseItem(String product, String date, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(product, style: const TextStyle(color: Colors.white)),
          Text(date, style: const TextStyle(color: Colors.white70)),
          Text(amount, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPendingOrders() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pending Orders', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 10),
          ...pendingOrders.map((order) => _buildPendingOrderItem(
            order['order'] ?? 'Unknown',
            order['date'] ?? 'Unknown',
          )),
        ],
      ),
    );
  }

  Widget _buildPendingOrderItem(String order, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(order, style: const TextStyle(color: Colors.white)),
          Text(date, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
