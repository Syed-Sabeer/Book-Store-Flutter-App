import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/admin/action/book_edit.dart'; // Import EditBookPage

class BookViewPage extends StatelessWidget {
  final Map<String, dynamic> bookData;

  const BookViewPage({super.key, required this.bookData});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios, color: TColor.primary),
          onPressed: () {
            Navigator.pop(context); // Go back to the book list
          },
        ),
        title:  Text(
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
              // Navigate to the edit book page
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
              // Handle delete action
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
                      bookData["img"] ?? '',
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
              _buildDetailRow("ID", bookData["id"] ?? 'No ID available'),
              _buildDetailRow("Publisher", bookData["publisher"] ?? 'No publisher available'),
              _buildDetailRow("Length", "${bookData["length"] ?? 'N/A'} pages"),
              _buildDetailRow("Language", bookData["language"] ?? 'No language available'),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              // Description Section
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
                bookData["description"] ?? "No description available.",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for building detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this book?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Handle book deletion
                _deleteBook(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // Function to delete the book
  void _deleteBook(BuildContext context) {
    // Add your deletion logic here, such as making a network request to delete the book
    // For example:
    // await FirebaseFirestore.instance.collection('books').doc(bookData["id"]).delete();

    // Assuming the deletion is successful, pop the current page and refresh the previous page
    Navigator.of(context).pop(); // Close the book view page
    Navigator.of(context).pop(); // Go back to the previous screen (book list)
  }
}
