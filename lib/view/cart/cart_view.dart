import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/view/checkout/checkout_view.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "The Disappearance of Emila Zola",
      "author": "Michael Rosen",
      "img": "assets/img/1.jpg",
      "price": 15.99,
      "quantity": 1
    },
    {
      "name": "Fatherhood",
      "author": "Marcus Berkmann",
      "img": "assets/img/2.jpg",
      "price": 12.50,
      "quantity": 2
    },
    {
      "name": "The Time Travellers Handbook",
      "author": "Stride Lottie",
      "img": "assets/img/3.jpg",
      "price": 10.99,
      "quantity": 1
    }
  ];

  double getTotalPrice() {
    return cartItems.fold(
        0, (total, item) => total + (item["price"] * item["quantity"]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
          "Cart",
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset(
                      item["img"].toString(),
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item["name"].toString()),
                    subtitle: Text("by ${item["author"]}"),
                    trailing: Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${item["price"].toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: TColor.money,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("Qty: ${item["quantity"]}"),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.red, // Change icon color to red
                            ),
                            onPressed: () {
                              setState(() {
                                cartItems.removeAt(index);
                              });
                            },
                          ),


                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: \$${getTotalPrice().toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColor.primary, // Your primary color defined in TColor
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Added padding for better appearance
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Text styling for the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners for the button
                    ),
                  ),
                  onPressed: () {
                    // Navigate to the CheckoutPage when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(), // CheckoutPage navigation
                      ),
                    );
                  },
                  child: const Text(
                    "Checkout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
