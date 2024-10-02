import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/admin/action/book_view.dart';
import 'package:book_grocer/admin/action/book_add.dart';
import 'package:book_grocer/admin/action/book_edit.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  final ImagePicker _picker = ImagePicker();

  // Fetch books from Firestore
  Stream<QuerySnapshot> fetchBooks() {
    return FirebaseFirestore.instance.collection('books').snapshots();
  }

  // Upload image to Firebase Storage and save the URL in Firestore
  Future<void> uploadImageAndSaveURL(String bookId) async {
    try {
      final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('images/${imageFile.name}');
        final uploadTask = await storageRef.putFile(File(imageFile.path));

        // Retrieve the download URL
        final downloadURL = await uploadTask.ref.getDownloadURL();

        // Save the download URL to Firestore
        FirebaseFirestore.instance.collection('books').doc(bookId).update({
          'imageurl': downloadURL,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully')),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image')),
      );
    }
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookViewPage(bookData: bookData),
      ),
    );
  }

  // Navigate to edit book page
  // void editBook(Map<String, dynamic> bookData) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => EditBookPage(bookData: bookData),
  //     ),
  //   );
  // }

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

                    // Handle null values with fallback values
                    final String imageUrl = book['imageurl'] ?? ''; // Provide an empty string if 'imageurl' is null
                    final String name = book['name'] ?? 'Unknown Book'; // Provide a default name if 'name' is null
                    final String author = book['author'] ?? 'Unknown Author'; // Provide a default author if 'author' is null
                    final double price = book['price'] != null ? book['price'].toDouble() : 0.0; // Provide a default price if 'price' is null

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
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl, // Fetch book image from Firestore
                            width: 50,
                            height: 75,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 50);
                            },
                          )
                              : const Icon(Icons.broken_image, size: 50), // Fallback if no image URL
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
