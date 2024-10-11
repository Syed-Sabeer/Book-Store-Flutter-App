import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:book_grocer/view/login/sign_in_view.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/view/checkout/checkout_view.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  // Function to check if the user is logged in
  void checkLoginStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not logged in, redirect to SignInView
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInView()),
        );
      });
    }
  }

  // Fetch cart items from Firestore
  Future<void> fetchCartItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Query the cart for the logged-in user
      var cartRef = FirebaseFirestore.instance
          .collection('cart')
          .where('userId', isEqualTo: user.uid);

      var cartSnapshot = await cartRef.get();
      if (cartSnapshot.docs.isNotEmpty) {
        var cartData = cartSnapshot.docs.first.data();
        List<String> bookIds = List<String>.from(cartData['bookIds']);
        List<int> quantities = List<int>.from(cartData['quantities']);

        // Fetch book details from 'books' collection
        for (int i = 0; i < bookIds.length; i++) {
          var bookDoc = await FirebaseFirestore.instance
              .collection('books')
              .doc(bookIds[i])
              .get();
          if (bookDoc.exists) {
            var bookData = bookDoc.data();
            cartItems.add({
              "name": bookData?['name'] ?? 'Unknown Title',
              "author": bookData?['author'] ?? 'Unknown Author',
              "img": bookData?['imageurl'] ?? 'assets/img/default.jpg',
              "price": bookData?['price'] ?? 0.0,
              "quantity": quantities[i],
            });
          }
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  double getTotalPrice() {
    return cartItems.fold(
        0, (total, item) => total + (item["price"] * item["quantity"]));
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchCartItems();
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
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
                    leading: Image.network(
                      item["img"].toString(),
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item["name"].toString()),
                    subtitle: Text("by ${item["author"]}"),
                    trailing: Column(
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
                    backgroundColor: TColor.primary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to the CheckoutPage when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const CheckoutPage(), // CheckoutPage navigation
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
          ),
        ],
      ),
    );
  }
}
