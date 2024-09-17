import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert'; // Import the dart:convert library for JSON decoding
import '../../common/color_extenstion.dart';

class UserViewPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserViewPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    // Convert `id` to int if it's a String
    final int userId = int.tryParse(user['id']?.toString() ?? '0') ?? 0;
    final int userOrders = int.tryParse(user['orders']?.toString() ?? '0') ?? 0;
    final int userReviews = int.tryParse(user['reviewsCount']?.toString() ?? '0') ?? 0;

    // Check and parse ordersDetails and reviews
    final ordersDetails = _parseList(user['ordersDetails']);
    final reviews = _parseList(user['reviews']);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:  Icon(Icons.arrow_back_ios, color: TColor.primary),
        ),
        title: Text(
          'User Details',
          style: TextStyle(color: TColor.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: user['profilePic'] ?? 'https://via.placeholder.com/70',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.person, size: 70),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'] ?? 'No Name Provided',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user['bio'] ?? 'No Bio Provided',
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Location Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${user['city'] ?? 'City Not Provided'}, ${user['country'] ?? 'Country Not Provided'}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // User Information Section
              Text(
                "User Information",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${user['email'] ?? 'Email Not Provided'}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('ID: $userId', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Shipping Address: ${user['shippingAddress'] ?? 'Address Not Provided'}', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Orders Section
              Text(
                "Orders",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(ordersDetails.length, (index) {
                    final order = ordersDetails[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text('Order ID: ${order['id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${order['date']}'),
                            Text('Books: ${order['books'].join(', ')}'),
                            Text('Quantity: ${order['quantity']}'),
                            Text('Total Price: \$${order['totalPrice']}'),
                          ],
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // Reviews Section
              Text(
                "Reviews",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(reviews.length, (index) {
                    final review = reviews[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text('Book: ${review['bookTitle']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Review: ${review['reviewText']}'),
                            Text('Rating: ${review['rating']}'),
                          ],
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              // Back Button
           
            ],
          ),
        ),
      ),
    );
  }

  List<dynamic> _parseList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is String) {
      // Handle if data is a string and convert to list if needed
      try {
        return List.from(json.decode(data) as Iterable);
      } catch (e) {
        print('Error parsing JSON string: $e');
        return [];
      }
    }
    try {
      return List.from(data as Iterable);
    } catch (e) {
      print('Error parsing list: $e');
      return [];
    }
  }
}


// Sample data for testing
void main() {
  runApp(const MaterialApp(
    home: UserViewPage(
      user: {
        'id': '123',
        'name': 'John Doe',
        'bio': 'Avid reader and book lover.',
        'profilePic': 'https://via.placeholder.com/70',
        'city': 'New York',
        'country': 'USA',
        'email': 'john.doe@example.com',
        'orders': '2',
        'reviewsCount': '3',  // Changed from 'reviews' to 'reviewsCount'
        'shippingAddress': '123 Main St, New York, NY 10001',
        'ordersDetails': [
          {
            'id': '1',
            'date': '2024-09-10',
            'books': ['Book A', 'Book B'],
            'quantity': 2,
            'totalPrice': 39.99,
          },
          {
            'id': '2',
            'date': '2024-09-12',
            'books': ['Book C'],
            'quantity': 1,
            'totalPrice': 19.99,
          },
        ],
        'reviews': [  // Ensure no duplicate key here
          {
            'bookTitle': 'Book A',
            'reviewText': 'Great read!',
            'rating': 5,
          },
          {
            'bookTitle': 'Book B',
            'reviewText': 'Interesting but slow at times.',
            'rating': 3,
          },
          {
            'bookTitle': 'Book C',
            'reviewText': 'Could not put it down!',
            'rating': 4,
          },
        ],
      },
    ),
  ));
}

