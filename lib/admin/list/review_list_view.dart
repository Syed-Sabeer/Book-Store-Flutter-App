import 'package:flutter/material.dart';
import 'package:book_grocer/admin/action/review_view.dart';
import '../../common/color_extenstion.dart';

class ReviewsListPage extends StatelessWidget {
  const ReviewsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reviews = [
      {
        'review': 'A thrilling historical adventure with an unexpected twist.',
        'bookImage': 'assets/img/1.jpg',
        'bookName': 'The Disappearance of Emila Zola',
        'userName': 'John Doe',
        'rating': 4.5,
        'date': '2024-09-10',
      },
      {
        'review': 'A heartfelt and emotional look at the trials of fatherhood.',
        'bookImage': 'assets/img/2.jpg',
        'bookName': 'Fatherhood',
        'userName': 'Jane Smith',
        'rating': 4.0,
        'date': '2024-09-11',
      },
      {
        'review': 'An intriguing guide to time travel, both fact and fiction.',
        'bookImage': 'assets/img/3.jpg',
        'bookName': 'The Time Travellers Handbook',
        'userName': 'Emily Clark',
        'rating': 5.0,
        'date': '2024-09-12',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
          onPressed: () {
            Navigator.pop(context); // Go back to the book list
          },
        ),
        title: Text(
          'Reviews',
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  review['bookImage'],
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                review['bookName'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['review'],
                    style: TextStyle(color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${review['rating']}',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reviewed by: ${review['userName']}',
                    style: TextStyle(color: TColor.primary, fontSize: 14),
                  ),
                  Text(
                    'Date: ${review['date']}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewViewPage(reviewDetails: review),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
