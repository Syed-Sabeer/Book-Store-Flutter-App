import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';

class BookSinglePage extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const BookSinglePage({super.key, required this.bookData});

  @override
  _BookSinglePageState createState() => _BookSinglePageState();
}

class _BookSinglePageState extends State<BookSinglePage> {
  int _quantity = 1; // Initial quantity
  double _userRating = 0; // User's rating
  final _reviewController = TextEditingController(); // Controller for review input

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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: TColor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                onPressed: () {
                  // Handle cart action
                },
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle
                  ),
                  child: const Text(
                    "1",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  widget.bookData["img"],
                  height: media.width * 0.6,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "\$${widget.bookData["price"].toStringAsFixed(2)} - \$${(widget.bookData["price"] * 1.5).toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
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
                widget.bookData["name"],
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 5),
              Text(
                "Author: ${widget.bookData["author"]}",
                style: const TextStyle(
                    fontSize: 16, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              const Text(
                "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Chip(
                    label: Text("Length ${widget.bookData["length"]} Pages"),
                    backgroundColor: Colors.grey[200],
                  ),
                  Chip(
                    label: Text("Language ${widget.bookData["language"]}"),
                    backgroundColor: Colors.grey[200],
                  ),
                  Chip(
                    label: Text("Publisher ${widget.bookData["publisher"]}"),
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
                    backgroundColor: TColor.primary,
                  ),
                  onPressed: () {
                    // Add to cart logic here
                  },
                  child: const Text(
                    "+ Add To Cart",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 75),

              Text(
                "Ratings & Reviews",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display existing reviews here (hardcoded for demo)
                  const ReviewTile(
                    reviewerName: "John Doe",
                    rating: 4,
                    review: "Amazing book! Really enjoyed reading it.",
                  ),
                  const SizedBox(height: 10),
                  const ReviewTile(
                    reviewerName: "Jane Smith",
                    rating: 3,
                    review: "Good read, but could have been better.",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Write Your Review",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (int i = 1; i <= 5; i++)
                    IconButton(
                      icon: Icon(
                        i <= _userRating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow,
                      ),
                      onPressed: () {
                        setState(() {
                          _userRating = i.toDouble();
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your review here...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primary,
                ),
                onPressed: () {
                  // Submit review logic here
                },
                child: const Text(
                  "Submit Review",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewTile extends StatefulWidget {
  final String reviewerName;
  final int rating;
  final String review;

  const ReviewTile({
    super.key,
    required this.reviewerName,
    required this.rating,
    required this.review,
  });

  @override
  _ReviewTileState createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  bool _liked = false; // Track if review is liked

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reviewerName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    for (int i = 1; i <= 5; i++)
                      Icon(
                        i <= widget.rating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  widget.review,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _liked ? Icons.favorite : Icons.favorite_border,
              color: _liked ? Colors.red : Colors.grey,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _liked = !_liked;
              });
            },
          ),
        ],
      ),
    );
  }
}
