// auth_helper.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:book_grocer/view/login/sign_in_view.dart';  // Import SignInView

void checkAuthenticationAndNavigate(BuildContext context, Widget page) {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Check if the user is logged in
  if (auth.currentUser != null) {
    // If logged in, navigate to the intended page
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  } else {
    // If not logged in, redirect to the login page
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInView()));
  }
}
