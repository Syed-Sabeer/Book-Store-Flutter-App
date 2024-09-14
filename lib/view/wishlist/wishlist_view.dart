import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_grocer/view/login/sign_in_view.dart';
import 'package:book_grocer/common/color_extenstion.dart';
// Import your HomeView

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Map<String, dynamic>> wishlistItems = [
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



  @override
  void initState() {
    super.initState();
    // Check if the user is logged in when the page is loaded
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
          "Wishlist",
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: wishlistItems.isEmpty
          ? const Center(child: Text("Your wishlist is empty"))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: wishlistItems.length,
        itemBuilder: (context, index) {
          var item = wishlistItems[index];
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "\$${item["price"].toStringAsFixed(2)}",
                    style: TextStyle(
                      color: TColor.money,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        wishlistItems.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
