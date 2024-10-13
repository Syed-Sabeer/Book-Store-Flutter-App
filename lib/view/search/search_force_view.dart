import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/color_extenstion.dart';
import 'package:book_grocer/view/book_detail/book_detail_view.dart';

class SearchForceView extends StatefulWidget {
  final Function(String)? didSearch;

  const SearchForceView({super.key, this.didSearch});

  @override
  State<SearchForceView> createState() => _SearchForceViewState();
}

class _SearchForceViewState extends State<SearchForceView> {
  TextEditingController txtSearch = TextEditingController();
  List<String> previousSearches = [
    "Search 1",
    "Search 2",
    "Search 3",
    "Search 4",
    "Search 5"
  ];

  List<Map<String, dynamic>> allBooks = []; // Hold fetched book data
  List<Map<String, dynamic>> filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _fetchBookNames(); // Fetch book names when the widget initializes
  }

  Future<void> _fetchBookNames() async {
    try {
      // Fetching book names from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('books').get();
      setState(() {
        allBooks = querySnapshot.docs.map((doc) => {
          'id': doc.id,
          'name': doc['name'],
          'author': doc['author'],
          'description': doc['description'],
          'genre': doc['genre'],
          'language': doc['language'],
          'length': doc['length'],
          'price': doc['price'],
          'publisher': doc['publisher'],
          'updatedAt': doc['updatedAt'],

          'img': doc['imageurl'] // Assuming 'imageurl' field exists
        }).toList();
        filteredBooks = allBooks; // Initialize filtered results
      });
    } catch (e) {
      print("Error fetching book names: $e");
      // Show an error message if fetching fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch book names: $e")),
      );
    }
  }

  void _filterResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredBooks = allBooks; // Show all results if the query is empty
      } else {
        // Filter results based on the query
        filteredBooks = allBooks
            .where((book) => book['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _navigateToBook(String bookId) {
    // Find the book data using the bookId
    final bookData = allBooks.firstWhere(
          (book) => book['id'] == bookId,
      orElse: () => {'id': '', 'name': '', 'author': '', 'img': ''}, // Return an empty book object instead of null
    );

    // Check if the book data is empty
    if (bookData['id'] != '') {
      // Navigate to the BookSinglePage with the book data and book ID
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookSinglePage(bookData: bookData, bookId: bookId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(),
        leadingWidth: 0,
        title: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: TColor.textbox,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: txtSearch,
                  onChanged: _filterResults, // Update results as user types
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: TColor.text),
                    hintText: "Search here",
                    labelStyle: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: TColor.text,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (txtSearch.text.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Text(
                "Previous Searches",
                style: TextStyle(
                  color: TColor.subTitle,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              itemCount: txtSearch.text.isEmpty
                  ? previousSearches.length
                  : filteredBooks.length,
              itemBuilder: (context, index) {
                var searchResultText = (txtSearch.text.isEmpty
                    ? previousSearches
                    : filteredBooks.map((book) => book['name']).toList())[index] as String? ?? "";
                var book = txtSearch.text.isEmpty ? null : filteredBooks[index];

                return GestureDetector(
                  onTap: () {
                    if (book != null) {
                      _navigateToBook(book['id']); // Navigate to book single page using book ID
                    } else {
                      // Handle previous searches click (if you need to handle that specifically)
                      // You could implement logic to navigate to a different page or show a dialog
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Row(
                      children: [
                        if (book != null) ...[
                          Image.network(
                            book['img'],
                            width: 40,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return const Icon(Icons.error); // Show error icon if image fails to load
                            },
                          ),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: Text(
                            searchResultText,
                            style: TextStyle(
                              color: TColor.text,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (book != null)
                          Text(
                            "times", // Assuming you might want to show search frequency
                            style: TextStyle(
                              color: TColor.primaryLight,
                              fontSize: 15,
                            ),
                          ),
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
