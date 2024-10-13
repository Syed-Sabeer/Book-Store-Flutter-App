import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderCancelledViewPage extends StatelessWidget {
  final String orderId; // The Firestore document ID of the order
  final Map<String, dynamic> order; // The order data

  const OrderCancelledViewPage({super.key, required this.orderId, required this.order});

  @override
  Widget build(BuildContext context) {
    // Extract order information from the provided 'order' map
    final List<dynamic> bookIds = order['bookIds'] ?? [];
    final List<dynamic> quantities = order['quantities'] ?? [];
    double shippingCost = 50.0; // Assuming fixed shipping cost, adjust as needed
    double productTotal = 0.0;

    // Calculate the product total based on quantities
    for (int i = 0; i < quantities.length; i++) {
      // Example price logic, you should adjust based on actual pricing from your database
      // Assume that the price per item is retrieved somewhere (hardcoded here for demo purposes)
      double itemPrice = 20.0; // Replace this with actual item prices from Firestore
      productTotal += (itemPrice * quantities[i]);
    }

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
                  _buildInfoRow('Order ID:', orderId), // Use the passed orderId
                  _buildInfoRow('User ID:', order['userId'] ?? 'N/A'),
                  _buildInfoRow('Total Amount:', '\$${order['total']?.toStringAsFixed(2) ?? '0.00'}'),
                  _buildInfoRow('Date:', (order['createdAt'] as Timestamp).toDate().toString()),
                  _buildInfoRow('Address:', order['address'] ?? 'N/A'),
                  _buildInfoRow('City:', order['city'] ?? 'N/A'),
                  _buildInfoRow('Postal Code:', order['postalCode'] ?? 'N/A'),
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
                    itemCount: bookIds.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(Icons.book, size: 50, color: TColor.primary), // Replace with actual book images if available
                          title: Text('Book ID: ${bookIds[index]}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Quantity: ${quantities[index]}'),
                          trailing: Text('\$${(20.0 * quantities[index]).toStringAsFixed(2)}', // Replace 20.0 with actual book price
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
