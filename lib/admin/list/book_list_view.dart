import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/admin/action/book_view.dart';
import 'package:book_grocer/admin/action/book_add.dart'; // Import AddBookPage
import 'package:book_grocer/admin/action/book_edit.dart'; // Import EditBookPage

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  // Sample list of books (replace this with actual data from your database or API)
  final List<Map<String, dynamic>> books = [
    {
      "id": "1",
      "name": "The Disappearance of Emila Zola",
      "author": "Michael Rosen",
      "price": 15.99,
      "img": "assets/img/1.jpg",
      "publisher": "Random House",
      "length": 320,
      "language": "English"
    },
    {
      "id": "2",
      "name": "Fatherhood",
      "author": "Bill Cosby",
      "price": 12.50,
      "img": "assets/img/2.jpg",
      "publisher": "Penguin",
      "length": 250,
      "language": "English"
    },
    {
      "id": "3",
      "name": "The Time Traveller's Handbook",
      "author": "Unknown",
      "price": 10.99,
      "img": "assets/img/3.jpg",
      "publisher": "HarperCollins",
      "length": 200,
      "language": "English"
    },
  ];

  // Navigate to add book page
  void addBook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddItemPage(), // Navigate to AddBookPage
      ),
    );
  }

  // Navigate to view book details page
  void viewBook(Map<String, dynamic> bookData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookViewPage(bookData: bookData),
      ),
    );
  }

  // Navigate to edit book page
  void editBook(Map<String, dynamic> bookData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookPage(bookData: bookData), // Pass bookData to EditBookPage
      ),
    );
  }

  // Functions to handle delete actions
  void deleteBook(String id) {
    setState(() {
      books.removeWhere((book) => book['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted book with ID: $id')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
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
          // Add Book Button
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
                  backgroundColor: TColor.primary, // Use backgroundColor instead of primary
                  foregroundColor: Colors.white, // Use foregroundColor instead of onPrimary
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ),

          // List of Books
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ListTile(
                    onTap: () => viewBook(book), // Navigate to the view page on card tap
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        book['img'],
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      '${book['name']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Author: ${book['author']}'),
                        Text('Price: \$${book['price'].toStringAsFixed(2)}'),
                      ],
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
