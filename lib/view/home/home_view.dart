import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/view/book_detail/book_detail_view.dart';
import 'package:flutter/material.dart';
import '../../common_widget/recently_cell.dart';
import '../../common_widget/top_picks_cell.dart';
import '../../common_widget/genres_cell.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import '../login/sign_up_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}
// Controllers for text fields
final TextEditingController txtName = TextEditingController();
final TextEditingController txtEmail = TextEditingController();


List<Map<String, dynamic>> genresArr = [
  {
    "name": "Graphic Novels",
    "img": "assets/img/g1.png"

  },
  {
    "name": "Graphic Novels",
    "img": "assets/img/g1.png"
  },
  {
    "name": "Graphic Novels",
    "img": "assets/img/g1.png"
  }
];

class _HomeViewState extends State<HomeView> {
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

  // Fetch Top Rated Books from Firestore
  Future<List<Map<String, dynamic>>> fetchTopRatedBooks() async {
    try {
      // Fetch all reviews with rating greater than 3
      QuerySnapshot reviewsSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('rating', isGreaterThan: 3)
          .get();

      // Create a map to hold total ratings and counts for each book
      Map<String, List<double>> bookRatings = {};
      for (var review in reviewsSnapshot.docs) {
        String bookId = review['bookId'];
        double rating = review['rating'].toDouble();
        if (!bookRatings.containsKey(bookId)) {
          bookRatings[bookId] = [0, 0]; // [totalRating, count]
        }
        bookRatings[bookId]![0] += rating; // total rating
        bookRatings[bookId]![1] += 1; // count
      }

      // Calculate average ratings and fetch book details
      List<Map<String, dynamic>> topRatedBooks = [];
      for (var entry in bookRatings.entries) {
        String bookId = entry.key;
        double averageRating = entry.value[0] / entry.value[1];

        // Fetch book details
        DocumentSnapshot bookDoc = await FirebaseFirestore.instance.collection('books').doc(bookId).get();
        topRatedBooks.add({
          'bookId': bookId,
          'name': bookDoc['name'],
          'author': bookDoc['author'],
          'img': bookDoc['imageurl'],
          'price': bookDoc['price'],
          'averageRating': averageRating,
        });
      }

      // Sort by average rating and get the top 7
      topRatedBooks.sort((a, b) => b['averageRating'].compareTo(a['averageRating']));
      return topRatedBooks.take(7).toList();
    } catch (e) {
      print('Error fetching top rated books: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
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
                    SizedBox(height: media.width * 0.05), // Reduced spacing
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: const Text(
                        "Book Store",
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
                    SizedBox(height: media.width * 0.05), // Reduced spacing
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

                    SizedBox(height: media.width * 0.0), // Reduced spacing
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: [
                        Text(
                          "Genres",
                          style: TextStyle(
                              color: TColor.text,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        )
                      ]),
                    ),
                    SizedBox(
                      height: media.width * 0.7,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                          scrollDirection: Axis.horizontal,
                          itemCount: genresArr.length,
                          itemBuilder: ((context, index) {
                            var bObj = genresArr[index];
                            return GestureDetector(
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     // MaterialPageRoute(
                              //     //   builder: (context) => BookSinglePage(bookData: bObj),
                              //     // ),
                              //   );
                              // },
                              child: GenresCell(
                                bObj: bObj,
                                bgcolor: index % 2 == 0
                                    ? TColor.color1
                                    : TColor.color2,
                              ),
                            );
                          })),
                    ),



                    // Top Rated Section
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Top Rated",
                            style: TextStyle(
                              color: TColor.text,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // FutureBuilder to fetch and display top rated books
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchTopRatedBooks(), // Assuming you have a method to fetch top-rated books
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text("No top-rated books found."));
                        }

                        List<Map<String, dynamic>> topRatedBooks = snapshot.data!;
                        return SizedBox(
                          height: media.width * 0.9,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                            scrollDirection: Axis.horizontal,
                            itemCount: topRatedBooks.length,
                            itemBuilder: (context, index) {
                              var bObj = topRatedBooks[index];
                              return TopPicksCell(
                                iObj: bObj,
                                bookId: bObj['bookId'], // Pass bookId here
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: media.width * 0.05),


                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: [
                        Text(
                          "Monthly Newsletter",
                          style: TextStyle(
                              color: TColor.text,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        )
                      ]),
                    ),

                    Container(
                      width: double.maxFinite,
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                          color: TColor.textbox.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Receive our monthly newsletter and receive updates on new stock, books and the occasional promotion.",
                              style: TextStyle(
                                color: TColor.subTitle,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            RoundTextField(
                              controller: txtName,
                              hintText: "Name",
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            RoundTextField(
                              controller: txtEmail,
                              hintText: "Email Address",
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                              MiniRoundButton(title: "Sign Up", onPressed:
                                  (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const SignUpView()));
                              }, )
                            ],)


                          ]),
                    ),



                    // Reduced spacing
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
