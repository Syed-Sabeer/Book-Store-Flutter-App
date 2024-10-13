import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/color_extenstion.dart'; // Ensure you have this for color themes
import '../../common_widget/recently_cell.dart'; // Import the RecentlyCell
import '../book_detail/book_detail_view.dart'; // Import your BookSinglePage

class GenreView extends StatelessWidget {
  final String genreName;

  const GenreView({super.key, required this.genreName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genreName),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('books')
            .where('genre', isEqualTo: genreName)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final books = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              childAspectRatio: 0.7, // Adjust the aspect ratio as needed
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              var bookData = books[index].data() as Map<String, dynamic>;
              String bookId = books[index].id; // Get book ID for navigation

              return RecentlyCell(
                iObj: bookData,
                bookId: bookId, // Pass the book ID
              );
            },
          );
        },
      ),
    );
  }
}
