import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../add new/add_new_item.dart';
import '../analytics/analytics.dart';
import '../dashboard/dashboard.dart';
import '../history/history.dart';
import '../profile/profile.dart';
import '../purchase/purchase.dart'; // Import if you are using fl_chart for charts

class AdminPanelView extends StatefulWidget {
  const AdminPanelView({Key? key}) : super(key: key);

  @override
  _AdminPanelViewState createState() => _AdminPanelViewState();
}

class _AdminPanelViewState extends State<AdminPanelView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      drawer: _buildSidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 20),
            _buildStatsSection(),
            const SizedBox(height: 20),
            _buildGraphSection(),
            const SizedBox(height: 20),
            _buildRecentActivitiesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Drawer(
      child: Container(
        color: Colors.black87,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: const Text(
                'Admin Panel',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildSidebarItem(Icons.person, 'Profile'),
            _buildSidebarItem(Icons.shopping_cart, 'Purchases'),
            _buildSidebarItem(Icons.analytics, 'Analytics'),
            _buildSidebarItem(Icons.history, 'History'),
            _buildSidebarItem(Icons.add_circle, 'Add New Item'),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _getPageForTitle(title)),
        );
      },
      hoverColor: Colors.blueGrey,
    );
  }

  Widget _getPageForTitle(String title) {
    switch (title) {
      case 'Profile':
        return ProfilePage(); // Make sure to replace with the correct page
      case 'Purchases':
        return PurchasesPage(); // Make sure to replace with the correct page
      case 'Analytics':
        return AnalyticsPage(); // Make sure to replace with the correct page
      case 'History':
        return HistoryPage(); // Make sure to replace with the correct page
      case 'Add New Item':
        return AddNewItemPage(); // Make sure to replace with the correct page
      default:
        return DashboardPage(); // Replace with a default page if necessary
    }
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back, Admin!',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Here is an overview of the latest statistics and activities.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatsCard('Products', Icons.shopping_bag, '150', Colors.purple),
          _buildStatsCard('Users', Icons.person, '500', Colors.teal),
          _buildStatsCard('Orders', Icons.receipt, '1200', Colors.orange),
          _buildStatsCard('Revenue', Icons.monetization_on, '\$34k', Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sales Overview',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 1),
                      FlSpot(1, 1.5),
                      FlSpot(2, 1.2),
                      FlSpot(3, 1.8),
                      FlSpot(4, 2.5),
                    ],
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activities',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildActivityItem('Added new product: Product XYZ', '2024-09-07'),
          _buildActivityItem('Updated user profile: Jane Smith', '2024-09-06'),
          _buildActivityItem('Processed 50 orders', '2024-09-05'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(activity, style: const TextStyle(color: Colors.white))),
          Text(date, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
