import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:book_grocer/view/genre/genre.dart'; // Import your GenreView

class SearchGridCell extends StatelessWidget {
  final Map<String, dynamic> sObj; // Specify the type of sObj
  final int index;

  const SearchGridCell({super.key, required this.sObj, required this.index});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // Navigate to GenreView with selected genre name
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenreView(genreName: sObj["name"]),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: TColor.searchBGColor[index % TColor.searchBGColor.length],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              sObj['img'] ?? 'assets/img/default.jpg', // Default image if null
              width: media.width * 0.25,
              height: media.width * 0.25,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              sObj['name'] ?? 'Unknown', // Default name if null
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
