import 'package:flutter/material.dart';
import '../../common/color_extenstion.dart';

class CheckoutPage extends StatefulWidget {
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

  final List<Map<String, dynamic>> cartItems = [
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

  final double shippingCost = 50.0;
  String selectedPaymentMethod = 'Credit Card';

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
            Navigator.pop(context); // Navigate back to the previous page
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: TColor.primary,
          ),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart Items Section
            Text(
              'Checkout',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: cartItems.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(item['image'], width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    title: Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                    trailing: Text('\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Delivery Detail Section
            Text(
              'Delivery Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextFormField(
                    controller: _addressController,
                    labelText: 'Address',
                    icon: Icons.location_on,
                  ),
                  SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _cityController,
                    labelText: 'City',
                    icon: Icons.location_city,
                  ),
                  SizedBox(height: 10),
                  _buildTextFormField(
                    controller: _postalCodeController,
                    labelText: 'Postal Code',
                    icon: Icons.local_post_office,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Payment Section
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                ListTile(
                  leading: Radio<String>(
                    value: 'Credit Card',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  title: Text('Credit Card'),
                ),
                ListTile(
                  leading: Radio<String>(
                    value: 'PayPal',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  title: Text('PayPal'),
                ),
                ListTile(
                  leading: Radio<String>(
                    value: 'Cash on Delivery',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  title: Text('Cash on Delivery'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Dynamic Payment Fields
            if (selectedPaymentMethod == 'Credit Card') ...[
              _buildTextFormField(
                controller: _cardNumberController,
                labelText: 'Card Number',
                icon: Icons.credit_card,
              ),
              SizedBox(height: 10),
              _buildTextFormField(
                controller: _cardHolderController,
                labelText: 'Card Holder Name',
                icon: Icons.person,
              ),
              SizedBox(height: 10),
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

            SizedBox(height: 20),

            // Order Summary Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 16),
                  _buildSummaryRow('Total Product Price', '\$${productTotal.toStringAsFixed(2)}'),
                  _buildSummaryRow('Shipping', '\$${shippingCost.toStringAsFixed(2)}'),
                  Divider(thickness: 1, color: Colors.grey),
                  _buildSummaryRow('Total Amount', '\$${finalTotal.toStringAsFixed(2)}', isBold: true),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Proceed to Pay Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order Placed Successfully')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: TColor.primary,
                ),
                child: Text('Proceed to Pay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
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
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
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
