import 'package:book_grocer/view/search/search_fiter_view.dart';
import 'package:book_grocer/view/search/search_force_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common_widget/history_row.dart';
import '../../common_widget/search_grid_cell.dart';
import '../../common/extenstion.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/view/genre/genre.dart'; // Import your GenreView

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController txtSearch = TextEditingController();
  int selectTag = 0; // Store selected tag index
  List<String> tagsArr = [
    "Genre",
    "New Release",
    "Most Sold",
  ];

  List<Map<String, dynamic>> searchArr = [
    {
      "name": "Biography",
      "img": "assets/img/b1.jpg",
    },
    {
      "name": "Business",
      "img": "assets/img/b2.jpg",
    },
    {
      "name": "Children",
      "img": "assets/img/b3.jpg",
    },
    {
      "name": "Cookery",
      "img": "assets/img/b4.jpg",
    },
    {
      "name": "Fiction",
      "img": "assets/img/b5.jpg",
    },
    {
      "name": "Graphic Novels",
      "img": "assets/img/b6.jpg",
    },
  ];

  List<Map<String, dynamic>> sResultArr = []; // Search results

  @override
  void initState() {
    super.initState();
    _fetchInitialResults(); // Fetch initial results if needed
  }

  Future<void> _fetchInitialResults() async {
    // Optional: Fetch some initial results or recommendations
  }

  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) {
      setState(() {
        sResultArr = []; // Clear results if query is empty
      });
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('books') // Change this to your books collection name
        .where(selectTag == 0 ? 'genre' : 'name', isGreaterThanOrEqualTo: query)
        .where(selectTag == 0 ? 'genre' : 'name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    setState(() {
      sResultArr = querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: TColor.textbox,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: txtSearch,
                  onChanged: (value) {
                    _searchBooks(value); // Trigger search on input change
                  },
                  onTap: () async {
                    // Navigate to SearchForceView for additional search options
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchForceView(
                          didSearch: (sText) {
                            txtSearch.text = sText;
                            if (mounted) {
                              setState(() {
                                _searchBooks(sText);
                              });
                            }
                          },
                        ),
                      ),
                    );
                    FocusScope.of(context).unfocus(); // Dismiss keyboard
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: TColor.text),
                    suffixIcon: SizedBox(
                      width: 40,
                      child: IconButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchFilterView(
                                didFilter: (fObj) {
                                  if (mounted) {
                                    setState(() {}); // Update state if filter applied
                                  }
                                },
                              ),
                            ),
                          );
                          FocusScope.of(context).unfocus(); // Dismiss keyboard
                        },
                        icon: Icon(Icons.tune, color: TColor.text),
                      ),
                    ),
                    hintText: "Search Books, Authors, or ISBN",
                    labelStyle: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            if (txtSearch.text.isNotEmpty)
              const SizedBox(width: 8),
            if (txtSearch.text.isNotEmpty)
              TextButton(
                onPressed: () {
                  txtSearch.clear(); // Clear search text
                  setState(() {
                    sResultArr = []; // Clear search results
                  });
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
        children: [
          // Tag selection
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: tagsArr.map((tagName) {
                  var index = tagsArr.indexOf(tagName);
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectTag = index; // Update selected tag
                        });
                      },
                      child: Text(
                        tagName,
                        style: TextStyle(
                          color: selectTag == index ? TColor.text : TColor.subTitle,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Display results
          if (txtSearch.text.isEmpty)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.75,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 15,
                ),
                itemCount: searchArr.length,
                itemBuilder: (context, index) {
                  var sObj = searchArr[index] as Map<String, dynamic>? ?? {};
                  return SearchGridCell(
                    sObj: sObj,
                    index: index,
                  );
                },
              ),
            ),
          // Search results
          if (txtSearch.text.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: sResultArr.length,
                itemBuilder: (context, index) {
                  var sObj = sResultArr[index] as Map<String, dynamic>? ?? {};
                  return GestureDetector(
                    onTap: () {
                      // Navigate to GenreView with selected genre data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GenreView(
                            genreName: sObj['genre'], // Pass the genre name
                          ),
                        ),
                      );
                    },
                    child: HistoryRow(
                      sObj: sObj,
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
