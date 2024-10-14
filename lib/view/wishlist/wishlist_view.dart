import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_grocer/view/login/sign_in_view.dart';
import 'package:book_grocer/common/color_extenstion.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Map<String, dynamic>> wishlistItems = [];

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

  Future<void> fetchWishlistItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch wishlist items for the logged-in user
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('wishlist')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        wishlistItems = snapshot.docs.map((doc) {
          return {
            'id': doc.id, // Store document ID for deletion
            'bookId': doc['bookId'],
            'createdAt': doc['createdAt'],
          };
        }).toList();
      });
    }
  }

  Future<Map<String, dynamic>?> fetchBookDetails(String bookId) async {
    // Fetch the book details from the books collection using the bookId
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('books')
        .doc(bookId)
        .get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }

  Future<void> deleteWishlistItem(String docId) async {
    await FirebaseFirestore.instance.collection('wishlist').doc(docId).delete();
    fetchWishlistItems(); // Refresh the wishlist after deletion
  }

  @override
  void initState() {
    super.initState();
    // Check if the user is logged in and fetch wishlist items
    checkLoginStatus();
    fetchWishlistItems();
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
          : FutureBuilder<List<Map<String, dynamic>>>(
        future: Future.wait(
          wishlistItems.map((item) async {
            // Fetch book details for each wishlist item
            var bookDetails = await fetchBookDetails(item['bookId']);
            return {
              'docId': item['id'], // Keep track of the document ID
              'bookDetails': bookDetails,
              'createdAt': item['createdAt'],
            };
          }).toList(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading wishlist"));
          }

          var itemsWithDetails = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: itemsWithDetails.length,
            itemBuilder: (context, index) {
              var item = itemsWithDetails[index];
              var bookDetails = item['bookDetails'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: bookDetails != null
                      ? Image.network(
                    bookDetails['imageurl'], // Use the image URL from book details
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                  )
                      : const SizedBox(width: 50, height: 75), // Placeholder if no image
                  title: Text(bookDetails?['name'] ?? "Unknown Book"), // Show book name
                  subtitle: Text("Added on: ${item['createdAt'].toDate()}"),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      deleteWishlistItem(item['docId']); // Delete item from wishlist
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
