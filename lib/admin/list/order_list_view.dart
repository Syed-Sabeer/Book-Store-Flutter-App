import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/admin/orders/cancelled_order_view.dart';
import 'package:book_grocer/admin/orders/pending_order_view.dart';
import 'package:book_grocer/admin/orders/completed_order_view.dart';
import 'package:book_grocer/admin/orders/shipped_order_view.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  _OrdersListPageState createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  // Sample data for new orders count
  final Map<String, int> newOrdersCount = {
    'Pending Orders': 5,
    'Shipped Orders': 2,
    'Completed Orders': 0,
    'Cancelled Orders': 1,
  };

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display the cards as buttons for each order status
            Expanded(
              child: ListView(
                children: [
                  _buildStatusCard(
                    context,
                    'Pending Orders',
                    Icons.pending_actions,
                    Colors.orange,
                    newOrdersCount['Pending Orders']!,
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PendingOrdersPage(),
                      ),
                    ),
                  ),
                  _buildStatusCard(
                    context,
                    'Shipped Orders',
                    Icons.local_shipping,
                    Colors.blue,
                    newOrdersCount['Shipped Orders']!,
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShippedOrdersPage(),
                      ),
                    ),
                  ),
                  _buildStatusCard(
                    context,
                    'Completed Orders',
                    Icons.check_circle,
                    Colors.green,
                    newOrdersCount['Completed Orders']!,
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompletedOrdersPage(),
                      ),
                    ),
                  ),
                  _buildStatusCard(
                    context,
                    'Cancelled Orders',
                    Icons.cancel,
                    Colors.red,
                    newOrdersCount['Cancelled Orders']!,
                        () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CancelledOrdersPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, String title, IconData icon, Color iconColor, int newCount, VoidCallback onTap) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: iconColor,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              contentPadding: const EdgeInsets.all(16.0),
            ),
            if (newCount > 0)
              Positioned(
                right: 16,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$newCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
