import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/admin/action/book_view.dart';
import 'package:book_grocer/admin/action/book_add.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  // Fetch books from Firestore
  Stream<QuerySnapshot> fetchBooks() {
    return FirebaseFirestore.instance.collection('books').snapshots();
  }

  // Navigate to add book page
  void addBook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddItemPage(),
      ),
    );
  }

  // Navigate to view book details page
  void viewBook(Map<String, dynamic> bookData) {
    // Ensure the bookData includes the document ID
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookViewPage(bookData: bookData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: TColor.primary,
          ),
        ),
        title: Text(
          "Book List",
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton.icon(
                onPressed: addBook,
                icon: const Icon(Icons.add, size: 20),
                label: const Text("Add Book"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  backgroundColor: TColor.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ),

          // List of Books from Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fetchBooks(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading books'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final books = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index].data() as Map<String, dynamic>;

                    // Add the document ID to the book data
                    book["id"] = books[index].id;  // Get document ID from Firestore

                    final String name = book['name'] ?? 'Unknown Book';
                    final String author = book['author'] ?? 'Unknown Author';
                    final double price = book['price'] != null ? book['price'].toDouble() : 0.0;

                    // Get the image URL from Firestore document
                    final String imageUrl = book['imageurl'] ?? ''; // Dynamic URL from Firestore

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: ListTile(
                        onTap: () => viewBook(book),  // Pass book data including ID
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl,
                            width: 50,
                            height: 75,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print("Error loading image: ${error.toString()}");
                              print("Image URL: $imageUrl"); // Print the URL for debugging
                              return const Icon(Icons.broken_image, size: 50);
                            },
                          )
                              : const Icon(Icons.broken_image, size: 50), // Fallback if no image
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Author: $author'),
                            Text('Price: \$${price.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
