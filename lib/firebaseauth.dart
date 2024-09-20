import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_grocer/view/login/sign_in_view.dart';
import 'package:book_grocer/view/main_tab/main_tab_view.dart';
import 'package:flutter/material.dart';

// Register a new user
Future<void> createUserWithEmailAndPassword(String emailAddress, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    User? user = credential.user;
    if (user != null) {
      // Navigate to SignInView after successful user creation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInView()),
      );
    }
    print('User created: ${credential.user?.uid}');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// Sign in a user
Future<void> signInWithEmailAndPassword(String emailAddress, String password, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    User? user = credential.user;
    if (user != null) {
      // Navigate to home or other view after successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainTabView()),
      );
    }
    print('Signed in: ${credential.user?.uid}');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// Sign out a user
Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInView()),
    );
    print('User signed out');
  } catch (e) {
    print('Error signing out: $e');
  }
}
