import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailView extends StatefulWidget {
  final String orderId;
  final String collection; // Passed from the previous page, i.e., orders/deleted_orders/etc.

  const OrderDetailView({super.key, required this.orderId, required this.collection});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  Map<String, dynamic>? orderData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  void fetchOrderDetails() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection(widget.collection)
          .doc(widget.orderId)
          .get();
      if (doc.exists) {
        setState(() {
          orderData = doc.data();
          isLoading = false;
        });
      } else {
        print("Order not found.");
      }
    } catch (e) {
      print("Error fetching order details: $e");
    }
  }

  String getStatus() {
    switch (widget.collection) {
      case 'deleted_orders':
        return "Cancelled";
      case 'shipped_orders':
        return "Shipped";
      case 'completed_orders':
        return "Delivered";
      default:
        return "Processing";
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderData == null
          ? const Center(child: Text('Order not found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order status
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "Order Status: ${getStatus()}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Address information
            Text(
              "Shipping Information",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Address: ${orderData!['address']}"),
            Text("City: ${orderData!['city']}"),
            Text("Postal Code: ${orderData!['postalCode']}"),
            const SizedBox(height: 20),

            // Payment Information
            Text(
              "Payment Method",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Payment Method: ${orderData!['paymentMethod']}"),
            const SizedBox(height: 20),

            // Order Items
            Text(
              "Order Items",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...List.generate(orderData!['bookIds'].length, (index) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('books')
                    .doc(orderData!['bookIds'][index])
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const SizedBox(); // Handle error
                  }

                  var bookData = snapshot.data!.data()
                  as Map<String, dynamic>;
                  return Card(
                    margin:
                    const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.network(
                        bookData['imageurl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(bookData['name']),
                      subtitle: Text(
                          "Quantity: ${orderData!['quantities'][index]}"),
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 20),

            // Order Total
            Text(
              "Total Amount: \$${orderData!['total']}",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Order Date
            Text(
              "Order Date: ${orderData!['createdAt'].toDate().toString()}",
              style: TextStyle(
                  fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
