import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:book_grocer/view/login/sign_in_view.dart';
import '../../common/color_extenstion.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardCVCController = TextEditingController();
  final TextEditingController _paypalEmailController = TextEditingController();

  List<Map<String, dynamic>> cartItems = [];

  final double shippingCost = 50.0;
  String selectedPaymentMethod = 'Credit Card'; // Default selection
  bool isLoading = true;

  // Fetch the cart data from Firestore
  Future<void> fetchCartItems() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final cartSnapshot = await FirebaseFirestore.instance
            .collection('cart')
            .doc(user.uid)
            .get();

        if (cartSnapshot.exists) {
          final data = cartSnapshot.data()!;
          List<dynamic> bookIds = data['bookIds'];
          List<dynamic> quantities = data['quantities'];

          for (int i = 0; i < bookIds.length; i++) {
            // Fetch each book's details from the 'books' collection
            final bookSnapshot = await FirebaseFirestore.instance
                .collection('books')
                .doc(bookIds[i])
                .get();

            if (bookSnapshot.exists) {
              final bookData = bookSnapshot.data()!;
              cartItems.add({
                "name": bookData['name'] ?? 'Unknown Book', // Fallback to 'Unknown Book' if 'name' is null
                "image": bookData['image'] ?? '', // Fallback to an empty string if 'image' is null
                "price": bookData['price'] ?? 0.0, // Fallback to 0.0 if 'price' is null
                "quantity": quantities[i],
                "bookId": bookIds[i], // Store the bookId for order insertion
              });
            }
          }
        }
      } catch (e) {
        print("Error fetching cart: $e");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void checkLoginStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInView()),
        );
      });
    } else {
      fetchCartItems();
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var item in cartItems) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double productTotal = calculateTotalPrice();
    double finalTotal = productTotal + shippingCost;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: TColor.primary,
          ),
        ),
        title: Text(
          "Checkout",
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart Items Section
            const Text(
              'Checkout',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: cartItems.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: item['image'] != ''
                          ? Image.network(item['image'],
                          width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported), // Show icon if no image
                    ),
                    title: Text(
                      item['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                    trailing: Text(
                      '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Delivery Detail Section
            const Text(
              'Delivery Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextFormField(
                    controller: _addressController,
                    labelText: 'Address',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _cityController,
                    labelText: 'City',
                    icon: Icons.location_city,
                  ),
                  const SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _postalCodeController,
                    labelText: 'Postal Code',
                    icon: Icons.local_post_office,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment Section
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // Payment method options
            ListTile(
              title: const Text('Credit Card'),
              leading: Radio<String>(
                value: 'Credit Card',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('PayPal'),
              leading: Radio<String>(
                value: 'PayPal',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Cash on Delivery'),
              leading: Radio<String>(
                value: 'Cash on Delivery',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            // Dynamic Payment Fields
            if (selectedPaymentMethod == 'Credit Card') ...[
              _buildTextFormField(
                controller: _cardNumberController,
                labelText: 'Card Number',
                icon: Icons.credit_card,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _cardHolderController,
                labelText: 'Card Holder Name',
                icon: Icons.person,
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                controller: _cardCVCController,
                labelText: 'CVC',
                icon: Icons.lock,
              ),
            ] else if (selectedPaymentMethod == 'PayPal') ...[
              _buildTextFormField(
                controller: _paypalEmailController,
                labelText: 'PayPal Email',
                icon: Icons.email,
              ),
            ],

            const SizedBox(height: 20),

            // Order Summary Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Total Product Price',
                      '\$${productTotal.toStringAsFixed(2)}'),
                  _buildSummaryRow(
                      'Shipping', '\$${shippingCost.toStringAsFixed(2)}'),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildSummaryRow('Total Amount',
                      '\$${finalTotal.toStringAsFixed(2)}',
                      isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Proceed to Pay Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    User? user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      // Collect the necessary data
                      String address = _addressController.text;
                      String city = _cityController.text;
                      String postalCode = _postalCodeController.text;
                      double totalAmount = finalTotal;

                      // Prepare the order data
                      Map<String, dynamic> orderData = {
                        'userId': user.uid,
                        'bookIds': cartItems
                            .map((item) => item['bookId'])
                            .toList(),
                        'quantities': cartItems
                            .map((item) => item['quantity'])
                            .toList(),
                        'total': totalAmount,
                        'address': address,
                        'city': city,
                        'postalCode': postalCode,
                        'paymentMethod': selectedPaymentMethod,
                        'createdAt': Timestamp.now(),
                      };

                      try {
                        // Insert the order into Firestore
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .add(orderData);

                        // Clear the cart (optional)
                        await FirebaseFirestore.instance
                            .collection('cart')
                            .doc(user.uid)
                            .delete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Order Placed Successfully')),
                        );
                      } catch (e) {
                        print("Error placing order: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to place order')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User not logged in')),
                      );
                    }
                  }
                },
                child: const Text('Proceed to Pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }
}
