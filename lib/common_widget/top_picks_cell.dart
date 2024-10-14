import 'package:flutter/material.dart';
import '../common/color_extenstion.dart';
import '../view/book_detail/book_detail_view.dart'; // Import the BookSinglePage

class TopPicksCell extends StatelessWidget {
  final Map<String, dynamic> iObj;
  final String bookId; // Include bookId

  const TopPicksCell({super.key, required this.iObj, required this.bookId});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    // Construct the image URL
    String imagePath = iObj["img"] ?? iObj["imageurl"] ?? 'assets/default_image.png'; // Fallback image
    String name = iObj["name"]?.toString() ?? 'Unknown Title';
    String author = iObj["author"]?.toString() ?? 'Unknown Author';
    double averageRating = iObj['averageRating']?.toDouble() ?? 0.0;

    return GestureDetector(
      onTap: () {
        // Navigate to BookSinglePage and pass bookData and bookId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookSinglePage(bookData: iObj, bookId: bookId), // Pass bookData and bookId
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        width: media.width * 0.32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imagePath,
                  width: media.width * 0.32,
                  height: media.width * 0.50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              name,
              maxLines: 3,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: TColor.text,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              author,
              maxLines: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: TColor.subTitle,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 14,
                ),
                Text(
                  averageRating.toStringAsFixed(1), // Display average rating
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
