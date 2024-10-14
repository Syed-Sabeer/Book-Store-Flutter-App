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
  bool _hasReviewed = false; // Track if the user has already reviewed this book
  bool _canSubmitReview = false; // Track if the user can submit a review
  List<Map<String, dynamic>> _reviews = []; // List to store fetched reviews
  bool _isInWishlist = false; // Track if the book is in the wishlist

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkIfReviewed(); // Check on initialization if the user has already reviewed this book
    _fetchReviews(); // Fetch reviews when the page is initialized
    _checkIfCanSubmitReview(); // Check if the user can submit a review
    _checkIfInWishlist(); // Check if the book is alre
  }
  Future<void> _checkIfInWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final wishlistQuery = await FirebaseFirestore.instance
        .collection('wishlist')
        .where('bookId', isEqualTo: widget.bookId)
        .where('userId', isEqualTo: user.uid)
        .get();

    setState(() {
      _isInWishlist = wishlistQuery.docs.isNotEmpty; // Update the state if the book is in the wishlist
    });
  }

  Future<void> _toggleWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to manage your wishlist')),
      );
      return;
    }

    final wishlistRef = FirebaseFirestore.instance.collection('wishlist');
    final wishlistDoc = await wishlistRef
        .where('bookId', isEqualTo: widget.bookId)
        .where('userId', isEqualTo: user.uid)
        .get();

    if (wishlistDoc.docs.isNotEmpty) {
      // If the book is already in the wishlist, remove it
      await wishlistDoc.docs.first.reference.delete();
      setState(() {
        _isInWishlist = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from wishlist')),
      );
    } else {
      // If the book is not in the wishlist, add it
      await wishlistRef.add({
        'bookId': widget.bookId,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      setState(() {
        _isInWishlist = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to wishlist')),
      );
    }
  }
  Future<void> _checkIfReviewed() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Query Firestore to see if the user has already submitted a review for this book
    final reviewQuery = await FirebaseFirestore.instance
        .collection('reviews')
        .where('bookId', isEqualTo: widget.bookId)
        .where('userId', isEqualTo: user.uid)
        .get();

    if (reviewQuery.docs.isNotEmpty) {
      setState(() {
        _hasReviewed = true; // User has already reviewed
      });
    }
  }


  Future<void> _checkIfCanSubmitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Check if the user has completed orders for the current book
    final orderQuery = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .where('bookIds', arrayContains: widget.bookId)
        .get();

    setState(() {
      _canSubmitReview = orderQuery.docs.isNotEmpty; // User can submit a review if they have a completed order
    });
  }

  Future<void> _fetchReviews() async {
    try {
      final reviewQuery = await FirebaseFirestore.instance
          .collection('reviews')
          .where('bookId', isEqualTo: widget.bookId)
          .get();

      // Collect user IDs from reviews
      List<String> userIds = reviewQuery.docs.map((doc) => doc['userId'] as String).toList();

      // Fetch emails in batch
      List<String> emails = await _getUserEmails(userIds);

      // Map reviews with corresponding emails
      setState(() {
        _reviews = reviewQuery.docs.map((doc) {
          String userId = doc['userId'];
          String reviewerEmail = emails[userIds.indexOf(userId)]; // Get email by index
          return {
            'reviewerName': reviewerEmail, // Store the user's email
            'rating': doc['rating'],
            'review': doc['review'],
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch reviews: $e')),
      );
    }
  }

  Future<List<String>> _getUserEmails(List<String> userIds) async {
    List<String> emails = [];

    for (String userId in userIds) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userDoc.exists && userDoc.data() != null) {
          emails.add(userDoc['email'] ?? "Unknown User");
        } else {
          emails.add("Unknown User"); // Handle non-existing user
          print('UserId $userId does not exist');
        }
      } catch (e) {
        emails.add("Unknown User");
        print('Error fetching email for userId $userId: $e');
      }
    }

    return emails;
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
        _fetchReviews(); // Refresh the review list
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

    String imageUrl = widget.bookData["img"] ?? widget.bookData["imageurl"] ?? "https://via.placeholder.com/150";
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

              // Wishlist Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: _toggleWishlist,
                  child: Text(
                    _isInWishlist ? "Remove from Wishlist" : "Add to Wishlist",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),


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
                    backgroundColor: TColor.primary,
                  ),
                  onPressed: _addToCart,
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Reviews",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              if (_reviews.isEmpty)
                const Text("No reviews yet.", style: TextStyle(color: Colors.grey)),
              for (var review in _reviews) ...[
                const SizedBox(height: 10),
                _buildReviewCard(review['reviewerName'], review['rating'], review['review']),
              ],
              if (_canSubmitReview && !_hasReviewed) ...[ // Check if the user can submit a review
                const SizedBox(height: 20),
                Text("Leave a review", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _buildRatingInput(),
                const SizedBox(height: 10),
                TextField(
                  controller: _reviewController,
                  decoration: const InputDecoration(
                    labelText: "Write your review",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitReview,
                  child: const Text("Submit Review"),
                ),
              ] else if (_hasReviewed) ...[
                const SizedBox(height: 10),
                const Text(
                  "You have already submitted a review for this book.",
                  style: TextStyle(color: Colors.grey),
                ),
              ] else ...[
                const SizedBox(height: 10),
                const Text(
                  "You need to purchase this book to leave a review.",
                  style: TextStyle(color: Colors.grey),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(String reviewerName, double rating, String review) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(reviewerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                _buildStarRating(rating), // Display the star rating
              ],
            ),
            const SizedBox(height: 5),
            Text(review),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      children: List.generate(fullStars, (index) => const Icon(Icons.star, color: Colors.yellow, size: 20)) +
          (hasHalfStar ? [const Icon(Icons.star_half, color: Colors.yellow, size: 20)] : []) +
          List.generate(emptyStars, (index) => const Icon(Icons.star_border, color: Colors.grey, size: 20)),
    );
  }

  Widget _buildRatingInput() {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          IconButton(
            icon: Icon(
              i <= _userRating ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            ),
            onPressed: () {
              setState(() {
                _userRating = i.toDouble(); // Set the user's rating
              });
            },
          ),
      ],
    );
  }
}
