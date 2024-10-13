import 'package:book_grocer/firebaseauth.dart';
import 'package:book_grocer/view/login/sign_in_view.dart'; // Import SignInView
import 'package:flutter/material.dart';
import '../../common/color_extenstion.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController txtFirstName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtMobile = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation

  // A method to validate the email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // A method to validate the password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  // A method to validate the first name
  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: TColor.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey, // Use the form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                    color: TColor.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                RoundTextField(
                  controller: txtFirstName,
                  hintText: "First Name",
                  validator: _validateFirstName, // Add first name validation
                ),
                const SizedBox(height: 20),

                RoundTextField(
                  controller: txtEmail,
                  hintText: "Email Address",
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail, // Add email validation
                ),
                const SizedBox(height: 20),

                RoundTextField(
                  controller: txtPassword,
                  hintText: "Password",
                  obscureText: true,
                  validator: _validatePassword, // Add password validation
                ),
                const SizedBox(height: 15),

                RoundLineButton(
                  title: "Sign Up",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) { // Validate the form
                      createUserWithEmailAndPassword(
                        txtEmail.text.trim(),
                        txtPassword.text.trim(),
                        context,
                      );
                    }
                  },
                ),
                const SizedBox(height: 15),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInView()),
                      );
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
