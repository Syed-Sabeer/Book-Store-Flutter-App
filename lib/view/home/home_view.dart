import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/view/book_detail/book_detail_view.dart';
import 'package:flutter/material.dart';
import '../../common_widget/recently_cell.dart';
import '../../common_widget/round_textfield.dart';
import '../../common_widget/top_picks_cell.dart';
import '../login/sign_up_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();

  // Define the GlobalKey for the Scaffold
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Fetch New Arrivals from Firestore
  Future<List<Map<String, dynamic>>> fetchNewArrivals() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('books')
          .orderBy('createdAt', descending: true) // Order by createdAt timestamp
          .limit(7) // Get the top 7 books
          .get();

      List<Map<String, dynamic>> books = [];
      for (var doc in snapshot.docs) {
        books.add({
          'bookId': doc.id, // Add the document ID here
          'name': doc['name'],
          'author': doc['author'],
          'img': doc['imageurl'], // Assuming your Firestore has this field
          'price': doc['price'],
          'length': doc['length'],
          'language': doc['language'],
          'publisher': doc['publisher'],
        });
      }
      return books;
    } catch (e) {
      print('Error fetching new arrivals: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = Uri.encodeFull("https://firebasestorage.googleapis.com/v0/b/book-store-a2922.appspot.com/o/images/2024-10-05%2015:28:26.818.png?alt=media&token=5cd380ba-9926-481d-8364-189f055d83a0");

    var media = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey, // Set the key for the Scaffold
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Align(
                  child: Transform.scale(
                    scale: 1.5,
                    origin: Offset(0, media.width * 0.8),
                    child: Container(
                      width: media.width,
                      height: media.width,
                      decoration: BoxDecoration(
                        color: TColor.primary,
                        borderRadius: BorderRadius.circular(media.width * 0.5),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: media.width * 0.1),
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: const Text(
                        "Our Top Picks",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      leading: Container(),
                      actions: [
                        IconButton(
                          onPressed: () {
                            // Open the end drawer using the scaffold key
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: const Icon(Icons.menu, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: media.width * 0.1),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "New Arrival",
                            style: TextStyle(
                              color: TColor.text,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // FutureBuilder to fetch and display new arrivals
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchNewArrivals(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("No new arrivals found."));
                        }

                        List<Map<String, dynamic>> newArrivals = snapshot.data!;
                        return SizedBox(
                          height: media.width * 0.9,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                            scrollDirection: Axis.horizontal,
                            itemCount: newArrivals.length,
                            itemBuilder: (context, index) {
                              var bObj = newArrivals[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookSinglePage(
                                        bookData: bObj,
                                        bookId: bObj['bookId'],
                                      ),
                                    ),
                                  );
                                },
                                child: RecentlyCell(
                                  iObj: bObj,
                                  bookId: bObj['bookId'],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: media.width * 0.1),
                    // Add other sections here as needed...
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}