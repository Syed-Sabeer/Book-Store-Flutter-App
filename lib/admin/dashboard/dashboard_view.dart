import 'package:flutter/material.dart';
import 'package:book_grocer/admin/list/book_list_view.dart';
import '../../common/color_extenstion.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: TColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: TColor.primary),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: TColor.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Syed Sabeer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'CEO',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Manage your store',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.book, color: TColor.primary),
              title: Text('Books'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookListPage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.person, color: TColor.primary),
              title: Text('Users'),
              onTap: () {
                Navigator.pushNamed(context, '/user-list'); // Ensure you have a route defined for this
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: TColor.primary),
              title: Text('Orders'),
              onTap: () {
                Navigator.pushNamed(context, '/orders'); // Ensure you have a route defined for this
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review, color: TColor.primary),
              title: Text('Reviews'),
              onTap: () {
                Navigator.pushNamed(context, '/reviews'); // Ensure you have a route defined for this
              },
            ),
            // Add more items as needed
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMetricCard(
                    context,
                    title: 'Total Books',
                    value: '250',
                    icon: Icons.book,
                  ),
                  _buildMetricCard(
                    context,
                    title: 'Total Users',
                    value: '1,200',
                    icon: Icons.person,
                  ),
                  _buildMetricCard(
                    context,
                    title: 'Total Orders',
                    value: '345',
                    icon: Icons.shopping_cart,
                  ),
                  _buildMetricCard(
                    context,
                    title: 'Total Reviews',
                    value: '1,500',
                    icon: Icons.rate_review,
                  ),
                  // Add more cards as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, {required String title, required String value, required IconData icon}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: TColor.primary,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
