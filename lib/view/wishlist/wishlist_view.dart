import 'package:book_grocer/common/color_extenstion.dart';
import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}
class _WishlistPageState extends State<WishlistPage> {
  List<Map<String, dynamic>> cartItems = [
    {
      "name": "The Disappearance of Emila Zola",
      "author": "Michael Rosen",
      "img": "assets/img/1.jpg",
      "price": 15.99,

    },
    {
      "name": "Fatherhood",
      "author": "Marcus Berkmann",
      "img": "assets/img/2.jpg",
      "price": 12.50,

    },
    {
      "name": "The Time Travellers Handbook",
      "author": "Stride Lottie",
      "img": "assets/img/3.jpg",
      "price": 10.99,

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
        title: Text("Wishlist"),
        backgroundColor: TColor.primary,
      ),
      body: cartItems.isEmpty
          ? Center(child: Text("Your wishlist is empty"))
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

                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
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

        ],
      ),
    );
  }
}
