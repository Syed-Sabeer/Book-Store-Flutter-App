import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/admin/action/order_view.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  _OrdersListPageState createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  // Sample order data
  final List<Map<String, dynamic>> _orders = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders List',
          style: TextStyle(
            color: TColor.primary, // Use theme color
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the order list
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: TColor.primary, // Use theme color
                        foregroundColor: Colors.white,
                        child: Text(
                          order['id'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        'Order ID: ${order['id']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('User: ${order['user']}'),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$${order['totalAmount']}',
                            style: TextStyle(
                              color: TColor.primary, // Use theme color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Date: ${order['date']}'),
                        ],
                      ),
                      contentPadding: const EdgeInsets.all(16.0),
                      onTap: () {
                        // Navigate to the OrderViewPage with order data
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
            ),
          ],
        ),
      ),
    );
  }
}
