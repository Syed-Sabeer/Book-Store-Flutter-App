import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewViewPage extends StatelessWidget {
  final Map<String, dynamic> reviewDetails;

  const ReviewViewPage({super.key, required this.reviewDetails});

  @override
  Widget build(BuildContext context) {
    // Use default values if data is null
    final bookImage = reviewDetails['bookImage'] ?? 'assets/img/placeholder.jpg';
    final bookName = reviewDetails['bookName'] ?? 'No Title';
    final review = reviewDetails['review'] ?? 'No review available';
    final userName = reviewDetails['userName'] ?? 'Anonymous';
    final rating = reviewDetails['rating']?.toString() ?? '0.0';
    final reviewDate = reviewDetails['date'] ?? DateTime.now().toIso8601String();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Details'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  bookImage,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              bookName,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Reviewed by: $userName',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 5),
                Text(
                  rating,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Review:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              review,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Date:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${DateFormat.yMMMd().format(DateTime.parse(reviewDate))}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
