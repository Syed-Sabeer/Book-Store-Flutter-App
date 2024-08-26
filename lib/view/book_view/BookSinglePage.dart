import 'package:flutter/material.dart';

class BookSinglePage extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const BookSinglePage({super.key, required this.bookData});

  @override
  _BookSinglePageState createState() => _BookSinglePageState();
}

class _BookSinglePageState extends State<BookSinglePage> {
  int _quantity = 1; // Initial quantity

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
        backgroundColor: Colors.transparent,
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
                    backgroundColor: Colors.black,
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
            ],
          ),
        ),
      ),
    );
  }
}
