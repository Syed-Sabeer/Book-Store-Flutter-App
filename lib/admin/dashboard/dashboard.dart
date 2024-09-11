import 'package:flutter/material.dart';

import '../../common/color_extenstion.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: TColor.primary,
      ),
      body: Center(
        child: const Text('Dashboard Content Goes Here'),
      ),
    );
  }
}
