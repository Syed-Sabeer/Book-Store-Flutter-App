import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';

class OrderViewPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderViewPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    final List<Map<String, dynamic>> orderItems = [
      {
        "name": "The Disappearance of Emila Zola",
        "image": "assets/img/1.jpg",
        "price": 15.99,
        "quantity": 1
      },
      {
        "name": "Fatherhood",
        "image": "assets/img/2.jpg",
        "price": 12.50,
        "quantity": 2
      },
      {
        "name": "The Time Travellers Handbook",
        "image": "assets/img/3.jpg",
        "price": 10.99,
        "quantity": 1
      }
    ];

    double shippingCost = 50.0;
    double productTotal = orderItems.fold(0, (sum, item) => sum + item['price'] * item['quantity']);
    double finalTotal = productTotal + shippingCost;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: TColor.primary,
          ),
        ),
        title: Text(
          "Order Details",
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping Info Section
                  const Text(
                    'Shipping Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Order ID:', order['id'] ?? 'N/A'),
                  _buildInfoRow('User:', order['user'] ?? 'N/A'),
                  _buildInfoRow('Total Amount:', '\$${order['totalAmount']?.toStringAsFixed(2) ?? '0.00'}'),
                  _buildInfoRow('Date:', order['date'] ?? 'N/A'),
                  _buildInfoRow('Address:', order['address'] ?? 'N/A'),
                  _buildInfoRow('City:', order['city'] ?? 'N/A'),
                  _buildInfoRow('Country:', order['country'] ?? 'N/A'),
                  _buildInfoRow('Phone:', order['phone'] ?? 'N/A'),
                  _buildInfoRow('Payment Method:', order['paymentMethod'] ?? 'N/A'),
                  const SizedBox(height: 20),

                  // Order Items Section
                  const Text(
                    'Order Items',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: orderItems.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = orderItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(item['image'], width: 50, height: 50, fit: BoxFit.cover),
                          ),
                          title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Quantity: ${item['quantity']}'),
                          trailing: Text('\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Price Calculation Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Price Calculation',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow('Total Product Price', '\$${productTotal.toStringAsFixed(2)}'),
                        _buildSummaryRow('Shipping', '\$${shippingCost.toStringAsFixed(2)}'),
                        const Divider(thickness: 1, color: Colors.grey),
                        _buildSummaryRow('Total Amount', '\$${finalTotal.toStringAsFixed(2)}', isBold: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Action Buttons Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle cancel order action here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order cancelled')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel Order',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle mark as shipped action here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order marked as shipped')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Mark as Shipped',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 16), textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.w700 : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.w700 : FontWeight.normal)),
        ],
      ),
    );
  }
}
