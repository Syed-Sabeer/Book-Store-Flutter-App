import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:flutter/material.dart';

import '../account/account_view.dart';
import '../home/home_view.dart';
import '../login/sign_in_view.dart';
import '../search/search_view.dart';
import '../cart/cart_view.dart'; // Import the CartPage
import '../wishlist/wishlist_view.dart'; // Import the WishlistPage

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> with TickerProviderStateMixin {
  TabController? controller;
  int selectMenu = 0;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    currentUser = FirebaseAuth.instance.currentUser;

    // Listen for authentication changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  List<Map<String, dynamic>> getMenuItems() {
    // Update the menu based on whether the user is logged in or not
    return [
      {"name": "Home", "icon": Icons.home},
      {
        "name": currentUser?.email ?? "Account",
        "icon": Icons.account_circle
      },
      {"name": currentUser != null ? "Logout" : "Login/Register", "icon": Icons.logout},
    ];
  }

  // Function to handle logout
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    List<Map<String, dynamic>> menuArr = getMenuItems();

    return Scaffold(
      key: GlobalKey<ScaffoldState>(), // Unique key for the Scaffold
      endDrawer: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 0,
        width: media.width * 0.8,
        child: Container(
          decoration: BoxDecoration(
            color: TColor.dColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(media.width * 0.7),
            ),
            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 15)],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: menuArr.map((mObj) {
                    var index = menuArr.indexOf(mObj);
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      decoration: selectMenu == index
                          ? BoxDecoration(color: TColor.primary, boxShadow: [
                        BoxShadow(color: TColor.primary, blurRadius: 10, offset: const Offset(0, 3)),
                      ])
                          : null,
                      child: GestureDetector(
                        onTap: () {
                          if (index == 0) {
                            Navigator.pop(context); // Close the drawer
                            controller!.animateTo(0); // Navigate to Home tab
                          } else if (index == 1) {
                            Navigator.pop(context); // Close the drawer
                            if (currentUser != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AccountView()),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignInView()),
                              );
                            }
                          } else if (index == 2) {
                            if (currentUser != null) {
                              _logout();
                            } else {
                              Navigator.pop(context); // Close the drawer
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignInView()),
                              );
                            }
                          }

                          setState(() {
                            selectMenu = index;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              mObj["name"].toString(),
                              style: TextStyle(
                                color: selectMenu == index ? Colors.white : TColor.text,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Icon(
                              mObj["icon"] as IconData? ?? Icons.home,
                              color: selectMenu == index ? Colors.white : TColor.primary,
                              size: 33,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.settings, color: TColor.subTitle, size: 25),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Terms",
                          style: TextStyle(color: TColor.subTitle, fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Privacy",
                          style: TextStyle(color: TColor.subTitle, fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: const [
          HomeView(),
          SearchView(),
          WishlistPage(),
          CartPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: TColor.primary,
        child: TabBar(
          controller: controller,
          indicatorColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.search), text: "Search"),
            Tab(icon: Icon(Icons.favorite_border), text: "Wishlist"),
            Tab(icon: Icon(Icons.shopping_cart), text: "Cart"),
          ],
        ),
      ),
    );
  }
}
