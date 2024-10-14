import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/color_extenstion.dart';
import 'edit_profile_view.dart';
import '../account/order_detail_view.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  List<Map<String, dynamic>> reviews = [];
  List<Map<String, dynamic>> allOrders = [];
  String userId = "";

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  void fetchUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      fetchReviews();
      fetchAllOrders();
    } else {
      print("No user is logged in.");
    }
  }

  void fetchReviews() async {
    if (userId.isEmpty) return;
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('userId', isEqualTo: userId)
          .get();

      setState(() {
        reviews = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return {
            'bookId': data['bookId'],
            'description': data['review'],
            'rate': data['rating'],
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching reviews: $e");
    }
  }

  void fetchAllOrders() async {
    if (userId.isEmpty) return;

    List<Map<String, dynamic>> tempOrders = [];
    List<String> collections = [
      'orders',
      'deleted_orders',
      'shipped_orders',
      'completed_orders'
    ];

    for (String collection in collections) {
      try {
        var snapshots = await FirebaseFirestore.instance
            .collection(collection)
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true) // Sort by createdAt descending
            .get();

        for (var doc in snapshots.docs) {
          var data = doc.data() as Map<String, dynamic>;
          var bookIds = data['bookIds'];

          // Fetching the book names and images for the order
          List<String> bookNames = [];
          List<String> bookImages = []; // List to hold book images
          for (var bookId in bookIds) {
            var bookDoc = await FirebaseFirestore.instance
                .collection('books')
                .doc(bookId)
                .get();
            if (bookDoc.exists) {
              var bookData = bookDoc.data() as Map<String, dynamic>;
              bookNames.add(bookData['name']);
              bookImages.add(bookData['imageurl']); // Add image URL to the list
            }
          }

          tempOrders.add({
            'orderId': doc.id,
            'bookIds': bookIds,
            'bookNames': bookNames,
            'bookImages': bookImages, // Add book images to the order
            'createdAt': data['createdAt'],
            'status': data['status'] ?? collection,
          });
        }
      } catch (e) {
        print("Error fetching orders from $collection: $e");
      }
    }

    setState(() {
      allOrders = tempOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: TColor.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Will Newman",
                          style: TextStyle(
                              color: TColor.text,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Constantly travelling and keeping up to date with business-related books.",
                          style: TextStyle(color: TColor.subTitle, fontSize: 13),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image.asset(
                      "assets/img/u1.png",
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  Icon(
                    Icons.near_me_sharp,
                    color: TColor.subTitle,
                    size: 15,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Newcastle - Australia",
                      style: TextStyle(color: TColor.subTitle, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 30.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.button),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: TColor.primary,
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfilePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Show reviews
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Your Reviews",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            if (reviews.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text("No reviews available."),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<DocumentSnapshot>( // Fetching book details
                    future: FirebaseFirestore.instance
                        .collection('books')
                        .doc(reviews[index]['bookId'])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return const SizedBox(); // Handle error or no data
                      }

                      var bookData = snapshot.data!.data() as Map<String, dynamic>;
                      return ListTile(
                        leading: Image.network(
                          bookData['imageurl'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(bookData['name']),
                        subtitle: Text(reviews[index]['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(reviews[index]['rate'], (index) => Icon(Icons.star, color: Colors.amber)),
                        ),
                      );
                    },
                  );
                },
              ),

            const SizedBox(height: 20),

            // Show all orders
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Your Orders",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            if (allOrders.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text("No orders available."),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allOrders.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Display book images and names in a single line
                          Expanded(
                            child: Row(
                              children: List.generate(allOrders[index]['bookImages'].length, (i) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Column(
                                    children: [
                                      Image.network(allOrders[index]['bookImages'][i],
                                          width: 50, height: 50, fit: BoxFit.cover),
                                      const SizedBox(height: 5),
                                      Text(allOrders[index]['bookNames'][i],
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            allOrders[index]['createdAt'].toDate().toString(), // Display order date
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetailView(
                                    orderId: allOrders[index]['orderId'],
                                    collection: allOrders[index]['status'],  // Pass the collection as the status
                                  ),
                                ),
                              );
                            },
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
