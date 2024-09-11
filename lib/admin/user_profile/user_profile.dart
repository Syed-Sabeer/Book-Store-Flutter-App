import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Placeholder for user profiles
  final List<Map<String, String>> users = [
    {'name': 'John Doe', 'email': 'johndoe@example.com'},
    {'name': 'Jane Smith', 'email': 'janesmith@example.com'},
    {'name': 'Alice Johnson', 'email': 'alicejohnson@example.com'},
  ];

  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profiles',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserList(),
            if (selectedUser != null) ...[
              const SizedBox(height: 20),
              _buildUserDetails(selectedUser!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
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
          const Text('Users List',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 10),
          ...users.map((user) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(user['name'] ?? '', style: const TextStyle(color: Colors.white)),
                  Text(user['email'] ?? '', style: const TextStyle(color: Colors.white70)),
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        selectedUser = user['name'];
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildUserDetails(String userName) {
    // Placeholder for user details
    // In a real application, you would fetch these details from a database or API
    final userDetails = {
      'Name': userName,
      'Email': '$userName@example.com',
      'Joined': 'Jan 2023',
    };

    final purchaseHistory = [
      {'product': 'Product 1', 'date': '2024-08-01', 'price': '\$29.99'},
      {'product': 'Product 2', 'date': '2024-08-15', 'price': '\$49.99'},
    ];

    final pendingOrders = [
      {'orderId': 'Order #1234', 'date': '2024-09-05', 'total': '\$89.99'},
      {'orderId': 'Order #5678', 'date': '2024-09-10', 'total': '\$109.99'},
    ];

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
          const Text('User Details',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 10),
          _buildDetailRow('Name:', userDetails['Name'] ?? ''),
          _buildDetailRow('Email:', userDetails['Email'] ?? ''),
          _buildDetailRow('Joined:', userDetails['Joined'] ?? ''),
          const SizedBox(height: 20),
          _buildPurchaseHistory(purchaseHistory),
          const SizedBox(height: 20),
          _buildPendingOrders(pendingOrders),
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

  Widget _buildPurchaseHistory(List<Map<String, String>> purchases) {
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
          const Text('Purchase History',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 10),
          ...purchases.map((purchase) {
            return _buildPurchaseItem(
              purchase['product'] ?? '',
              purchase['date'] ?? '',
              purchase['price'] ?? '',
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPurchaseItem(String productName, String date, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(productName, style: const TextStyle(color: Colors.white)),
          Text(date, style: const TextStyle(color: Colors.white70)),
          Text(price, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPendingOrders(List<Map<String, String>> orders) {
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
          const Text('Pending Orders',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 10),
          ...orders.map((order) {
            return _buildPendingOrderItem(
              order['orderId'] ?? '',
              order['date'] ?? '',
              order['total'] ?? '',
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPendingOrderItem(String orderId, String date, String total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(orderId, style: const TextStyle(color: Colors.white)),
          Text(date, style: const TextStyle(color: Colors.white70)),
          Text(total, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
