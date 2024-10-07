import 'package:book_grocer/common/color_extenstion.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookSinglePage extends StatefulWidget {
  final Map<String, dynamic> bookData;
  final String bookId;

  const BookSinglePage({required this.bookData, required this.bookId, Key? key}) : super(key: key);

  @override
  _BookSinglePageState createState() => _BookSinglePageState();
}

class _BookSinglePageState extends State<BookSinglePage> {
  int _quantity = 1; // Initial quantity
  double _userRating = 0; // User's rating
  final _reviewController = TextEditingController(); // Controller for review input

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<void> _addToCart() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to add books to the cart')),
        );
        return;
      }

      final cartRef = FirebaseFirestore.instance.collection('cart').doc(user.uid);
      final cartSnapshot = await cartRef.get();

      String? bookId = widget.bookId;
      if (bookId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book ID is null')),
        );
        return;
      }

      if (cartSnapshot.exists) {
        List<dynamic> bookIds = cartSnapshot['bookIds'] ?? [];
        List<dynamic> quantities = cartSnapshot['quantities'] ?? [];

        int bookIndex = bookIds.indexOf(bookId);
        if (bookIndex >= 0) {
          quantities[bookIndex] += _quantity;
        } else {
          bookIds.add(bookId);
          quantities.add(_quantity);
        }

        await cartRef.update({
          'bookIds': bookIds,
          'quantities': quantities,
        });
      } else {
        await cartRef.set({
          'userId': user.uid,
          'bookIds': [bookId],
          'quantities': [_quantity],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book added to cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }

  Future<void> _submitReview() async {
    if (_userRating == 0 || _reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide both a rating and a review')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to submit a review')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('reviews').add({
        'bookId': widget.bookId,
        'userId': user.uid,
        'rating': _userRating,
        'review': _reviewController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );

      setState(() {
        _userRating = 0;
        _reviewController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    String imageUrl = widget.bookData["imageurl"] ?? "https://example.com/default_image.png"; // Default image
    String bookName = widget.bookData["name"] ?? "Unknown Book";
    String author = widget.bookData["author"] ?? "Unknown Author";
    double price = widget.bookData["price"] ?? 0.0;
    String length = widget.bookData["length"]?.toString() ?? "N/A";
    String language = widget.bookData["language"] ?? "Unknown";
    String publisher = widget.bookData["publisher"] ?? "Unknown Publisher";
    String description = widget.bookData["description"] ?? "No description available";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  height: media.width * 0.6,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 60);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "\$${price.toStringAsFixed(2)} ",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  Icon(Icons.star_half, color: Colors.yellow, size: 20),
                  Icon(Icons.star_outline, color: Colors.grey, size: 20),
                  SizedBox(width: 10),
                  Text("(350 reviews)", style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                bookName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Author: $author",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Chip(
                    label: Text("Length: $length Pages"),
                    backgroundColor: Colors.grey[200],
                  ),
                  Chip(
                    label: Text("Language: $language"),
                    backgroundColor: Colors.grey[200],
                  ),
                  Chip(
                    label: Text("Publisher: $publisher"),
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.black),
                    onPressed: _decrementQuantity,
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    onPressed: _incrementQuantity,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _addToCart,
                  child: const Text(
                    "+ Add To Cart",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 75),
              const Text(
                "Ratings & Reviews",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ReviewTile(
                    reviewerName: "John Doe",
                    rating: 4,
                    review: "Amazing book! Really enjoyed reading it.",
                  ),
                  SizedBox(height: 10),
                  ReviewTile(
                    reviewerName: "Jane Smith",
                    rating: 5,
                    review: "A must-read for everyone.",
                  ),
                  SizedBox(height: 10),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Write your review",
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Rate this book:"),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _userRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.yellow,
                        ),
                        onPressed: () {
                          setState(() {
                            _userRating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _submitReview,
                  child: const Text(
                    "Submit Review",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  final String reviewerName;
  final double rating;
  final String review;

  const ReviewTile({
    Key? key,
    required this.reviewerName,
    required this.rating,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reviewerName, style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.yellow,
                );
              }),
            ),
            const SizedBox(height: 5),
            Text(review),
          ],
        ),
      ),
    );
  }
}
