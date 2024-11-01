import 'package:book_grocer/view/main_tab/main_tab_view.dart';
import 'package:book_grocer/admin/dashboard/dashboard_view.dart';
import 'package:book_grocer/common/color_extenstion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is fully initialized before app starts
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  // Enable Firestore persistence
  FirebaseFirestore.instance.settings =
  const Settings(persistenceEnabled: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Store App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primary,
        fontFamily: 'SF Pro Text',
      ),
      home: const MainTabView(), // Set MainTabView as the home
    );
  }
}
