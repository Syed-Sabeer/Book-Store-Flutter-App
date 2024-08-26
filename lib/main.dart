import 'package:flutter/material.dart';
import 'package:book_grocer/view/cart/cart_page.dart'; // Import CartPage
import 'package:book_grocer/view/checkout/CheckoutPage.dart'; // Import CheckoutPage
import 'package:book_grocer/view/main_tab/main_tab_view.dart';
import 'package:book_grocer/view/onboarding/onboarding_view.dart';
import 'package:book_grocer/common/color_extenstion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primary,
        fontFamily: 'SF Pro Text',
      ),
      home: const MainTabView(),
      routes: {
        '/cart': (context) => const CartPage(), // Define route for CartPage
        '/checkout': (context) => const CheckoutPage(), // Define route for CheckoutPage
      },
    );
  }
}
