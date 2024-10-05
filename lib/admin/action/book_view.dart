import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Required for Firestore operations
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/admin/action/book_edit.dart'; // Import EditBookPage

class BookViewPage extends StatelessWidget {
  final Map<String, dynamic> bookData;

  const BookViewPage({super.key, required this.bookData});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    // Debug print statement to check the img URL and book ID
    print("Book Image URL: ${bookData["imageurl"]}");
    print("Book Data: $bookData"); // Added print statement for all book data

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
          onPressed: () {
            Navigator.pop(context); // Go back to the book list
          },
        ),
        title: Text(
          "Book Details",
          style: TextStyle(
            color: TColor.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () {
              // Navigate to the edit book page with bookData
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBookPage(bookData: bookData),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.black),
            onPressed: () {
              _showDeleteConfirmation(context);
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
              // Book Cover Image
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      bookData["imageurl"] ?? '',
                      height: media.width * 0.6,
                      width: media.width * 0.4,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Book Name
              Text(
                bookData["name"] ?? 'No name available',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),

              // Author
              Text(
                "Author: ${bookData["author"] ?? 'No author available'}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),

              // Price
              Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.green),
                  const SizedBox(width: 5),
                  Text(
                    "\$${(bookData["price"] ?? 0).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Divider
              const Divider(),
              const SizedBox(height: 10),

              // Book Details
              const Text(
                "Book Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Additional Book Information
              _buildDetailRow("ID", bookData["id"]),
              _buildDetailRow("Publisher", bookData["publisher"]),
              _buildDetailRow("Language", bookData["language"]),
              _buildDetailRow("Length", "${bookData["length"]} pages"),

              // Add Book Description (Optional)
              if (bookData["description"] != null) ...[
                const SizedBox(height: 20),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  bookData["description"] ?? 'No description available',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Build the rows for book details
  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            value != null ? value.toString() : 'N/A',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Book"),
        content: const Text("Are you sure you want to delete this book?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Debugging print statement before deletion attempt
              print("Attempting to delete document with ID: ${bookData["id"]}");

              // Use the Firestore document reference directly
              var bookRef = FirebaseFirestore.instance.collection('books').doc(bookData["id"]);

              // Check if the document exists before trying to delete
              bookRef.get().then((doc) {
                if (doc.exists) {
                  // Attempt to delete the book
                  bookRef.delete().then((_) {
                    print("Book deleted successfully.");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Book deleted successfully.")),
                    );
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context); // Go back to the previous screen
                  }).catchError((error) {
                    print("Error deleting book: $error");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error deleting book: $error")),
                    );
                  });
                } else {
                  print("Document does not exist. Document ID: ${bookData["id"]}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Document does not exist.")),
                  );
                }
              }).catchError((error) {
                print("Error fetching document: $error");
              });
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
