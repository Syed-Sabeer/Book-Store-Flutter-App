import 'package:flutter/material.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:book_grocer/admin/action/user_view.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  // Search query to filter users
  String _searchQuery = '';

  // Sample user data
  final List<Map<String, dynamic>> _users = [
    {
      "id": "1",
      "email": "john.doe@example.com",
      "password": "password123",
      "profilePic": "https://www.w3schools.com/w3images/avatar2.png",
      "name": "John Doe",
      "city": "New York",
      "country": "USA",
      "bio": "An avid reader and book lover.",
      "orders": "15",
      "reviews": "3",
      "shippingAddress": "123 Main St, New York, NY 10001",
      "ordersDetails": [], // Add default empty list
      "reviewsDetails": [], // Add default empty list
    },
    {
      "id": "2",
      "email": "jane.smith@example.com",
      "password": "password456",
      "profilePic": "https://www.w3schools.com/w3images/avatar6.png",
      "name": "Jane Smith",
      "city": "Los Angeles",
      "country": "USA",
      "bio": "A bookworm with a passion for novels.",
      "orders": "23",
      "reviews": "5",
      "shippingAddress": "456 Elm St, Los Angeles, CA 90001",
      "ordersDetails": [], // Add default empty list
      "reviewsDetails": [], // Add default empty list
    },
    // Add more users if needed
  ];

  @override
  Widget build(BuildContext context) {
    // Filter the user list based on the search query
    final filteredUsers = _users.where((user) {
      return user['email']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users List',
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search field
            TextField(
              decoration: InputDecoration(
                labelText: 'Search by email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            const SizedBox(height: 20),
            // Display the filtered user list
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(user['profilePic']),
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                      ),
                      title: Text(user['email']),
                      subtitle: Text('ID: ${user['id']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.visibility, color: Colors.green),
                        onPressed: () {
                          // Navigate to the UserViewPage with user data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserViewPage(user: user),
                            ),
                          );
                        },
                      ),
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
